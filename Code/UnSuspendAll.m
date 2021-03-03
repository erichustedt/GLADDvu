function app = UnSuspendAll(app)
      % reenable buttons
      for i = 1:length(app.bucket.Suspended)
        try
        	app.bucket.Suspended(i).Enable = 'on';
        catch
        end
      end
      app.bucket.Suspended = [];
      drawnow;
