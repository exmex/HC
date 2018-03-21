package com.studioirregular.libinappbilling;

public class StopWatch {

	public synchronized void start() {
		
		this.startTime = System.currentTimeMillis();
	}
	
	/*
	 * Return elapsed time (since start) in milliseconds.
	 */
	public synchronized long stop() throws RuntimeException {
		
		if (startTime == 0) {
			throw new RuntimeException(
					"StopWatch: you are stopping a watch that not started before.");
		}
		
		long result = System.currentTimeMillis() - startTime;
		
		startTime = 0;
		
		return result;
	}
	
	private long startTime;
}
