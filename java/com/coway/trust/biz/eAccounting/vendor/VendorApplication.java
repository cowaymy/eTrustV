package com.coway.trust.biz.eAccounting.vendor;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

public interface VendorApplication {

	void insertVendorAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);

	void updateVendorAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);

}
