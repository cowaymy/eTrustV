package com.coway.trust.web.common.excel.upload;

import java.util.List;
import java.util.Map;

public interface ExcelUploadDBHandler {
	void processDB(String queryId, List<Map<String, Object>> dataMapList);
}
