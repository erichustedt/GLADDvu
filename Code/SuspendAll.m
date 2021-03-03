function app = SuspendAll(app)     
      % disable buttons until data is loaded;
      app.bucket.Suspended = findall(0,'Enable','on');
      set(app.bucket.Suspended,'Enable','off');
      drawnow;

