import matlab.engine
eng = matlab.engine.start_matlab()
eng.heartRate_monitor(nargout=0)
eng.quit()