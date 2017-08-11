package com.coway.trust.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

import org.apache.tika.Tika;

public class MimeTypeUtil {
	private MimeTypeUtil() {
	}

	private static final Map<String, String> ALLOW_MIME_TYPE = new HashMap();

	static {
		ALLOW_MIME_TYPE.put("image/bmp", "image/bmp");
		ALLOW_MIME_TYPE.put("image/x-png", "image/x-png");
		ALLOW_MIME_TYPE.put("image/png", "image/png");
		ALLOW_MIME_TYPE.put("image/gif", "image/gif");
		ALLOW_MIME_TYPE.put("image/ief", "image/ief");
		ALLOW_MIME_TYPE.put("image/jpeg", "image/jpeg");
		ALLOW_MIME_TYPE.put("image/tiff", "image/tiff");
		ALLOW_MIME_TYPE.put("image/x-cmu-raster", "image/x-cmu-raster");
		ALLOW_MIME_TYPE.put("image/x-portable-anymap", "image/x-portable-anymap");
		ALLOW_MIME_TYPE.put("image/x-portable-bitmap", "image/x-portable-bitmap");
		ALLOW_MIME_TYPE.put("image/x-portable-graymap", "image/x-portable-graymap");
		ALLOW_MIME_TYPE.put("image/x-portable-pixmap", "image/x-portable-pixmap");
		ALLOW_MIME_TYPE.put("application/pdf", "application/pdf");
		ALLOW_MIME_TYPE.put("application/xls", "application/xls");
		ALLOW_MIME_TYPE.put("application/x-tika-ooxml", "application/x-tika-ooxml");
//		ALLOW_MIME_TYPE.put("text/plain", "text/plain");
	}

	public static boolean isAllowFile(InputStream inputStream) throws IOException {
		Tika tika = new Tika();
		String mimeType = tika.detect(inputStream);
		return ALLOW_MIME_TYPE.containsKey(mimeType);
	}

	public static boolean isNotAllowFile(InputStream inputStream) throws IOException {
		return !isAllowFile(inputStream);
	}
}
