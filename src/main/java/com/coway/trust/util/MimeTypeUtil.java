package com.coway.trust.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

import org.apache.commons.collections.map.HashedMap;
import org.apache.tika.Tika;

public class MimeTypeUtil {
	private MimeTypeUtil() {
	}

	private static final Map<String, String> Allow_MIME_TYPE = new HashedMap();

	static {
		Allow_MIME_TYPE.put("image/bmp", "image/bmp");
		Allow_MIME_TYPE.put("image/x-png", "image/x-png");
		Allow_MIME_TYPE.put("image/png", "image/png");
		Allow_MIME_TYPE.put("image/gif", "image/gif");
		Allow_MIME_TYPE.put("image/ief", "image/ief");
		Allow_MIME_TYPE.put("image/jpeg", "image/jpeg");
		Allow_MIME_TYPE.put("image/tiff", "image/tiff");
		Allow_MIME_TYPE.put("image/x-cmu-raster", "image/x-cmu-raster");
		Allow_MIME_TYPE.put("image/x-portable-anymap", "image/x-portable-anymap");
		Allow_MIME_TYPE.put("image/x-portable-bitmap", "image/x-portable-bitmap");
		Allow_MIME_TYPE.put("image/x-portable-graymap", "image/x-portable-graymap");
		Allow_MIME_TYPE.put("image/x-portable-pixmap", "image/x-portable-pixmap");
		Allow_MIME_TYPE.put("application/pdf", "application/pdf");
		Allow_MIME_TYPE.put("application/xls", "application/xls");
	}

	public static boolean isAllowFile(InputStream inputStream) throws IOException {
		Tika tika = new Tika();
		String mimeType = tika.detect(inputStream);
		return Allow_MIME_TYPE.containsKey(mimeType);
	}

	public static boolean isNotAllowFile(InputStream inputStream) throws IOException {
		return isAllowFile(inputStream) == false;
	}
}
