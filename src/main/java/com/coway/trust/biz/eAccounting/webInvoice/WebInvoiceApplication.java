package com.coway.trust.biz.eAccounting.webInvoice;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

public interface WebInvoiceApplication {
	
	void insertWebInvoiceAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);
	
	void updateWebInvoiceAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);

}
