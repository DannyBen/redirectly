require 'spec_helper'

describe Command do
  subject { CLI.router }
  let(:config_path) { 'spec/fixtures/redirects.ini' }
  let(:default_args) {{ app: Redirectly::App, Port: 3000, environment: 'production' }}

  context "without arguments" do
    it "starts the server with redirects.yml" do
      Dir.chdir "spec/fixtures" do
        expect(Rack::Server).to receive(:start).with(default_args)
        subject.run
      end
    end
  end

  context "with --help" do
    it "shows detailed usage" do
      expect { subject.run %W[ --help ] }.to output_approval('cli/help')
    end
  end

  context "with --version" do
    it "shows version number" do
      expect { subject.run %W[ --version ] }.to output("#{VERSION}\n").to_stdout
    end
  end

  context "with --init" do
    before { reset_tmp_dir }

    it "creates a template redirects.ini file" do
      Dir.chdir tmp_dir do
        expect { subject.run %w[--init] }.to output_approval("cli/init")
        expect(File).to exist("redirects.ini")
        expect(File.read "redirects.ini").to match_approval("cli/init-template")
      end
    end

    context "when redirects.ini already exists" do
      it "does not overwrite the file" do
        Dir.chdir tmp_dir do
          File.write "redirects.ini", "dummy = sample"
          expect { subject.run %w[--init] }.to raise_approval("cli/init-error")
          expect(File.read "redirects.ini").to eq "dummy = sample"
        end
      end
    end
  end

  context "with a CONFIG argument" do
    it "starts the server with the specified path" do
      expect(Rack::Server).to receive(:start).with(default_args)
      subject.run %w[spec/fixtures/redirects.ini]
    end
  end

  context "with --port" do
    let(:args) {{ app: Redirectly::App, Port: 1234, environment: 'production' }}
    it "starts the server and listens on the requested port" do
      expect(Rack::Server).to receive(:start).with(args)
      subject.run %w[spec/fixtures/redirects.ini --port 1234]
    end
  end
end
