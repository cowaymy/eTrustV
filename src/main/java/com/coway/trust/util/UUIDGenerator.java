package com.coway.trust.util;

import java.util.UUID;

/**
 * UUID 생성 클래스
 */
public final class UUIDGenerator {
	private UUIDGenerator() {
	}

	private static final Object MUTEX = new Object();

	/**
	 * 36 Bytes 체계의 UUID 를 생성 하여 반환
	 * 
	 * @see <a href="https://en.wikipedia.org/wiki/Universally_unique_identifier">UUID on Wiki</a>
	 * @return UUID 36 Bytes 체계의 UUID
	 */
	public static final String uuid() {
		synchronized (MUTEX) {
			return UUID.randomUUID().toString();
		}
	}

	/**
	 * 32 Bytes 체계의 UUID 를 생성 하여 반환 (하이픈 '-' 제거)
	 * 
	 * @return UUID
	 */
	public static final String get() {
		return uuid().replace("-", "");
	}
}
