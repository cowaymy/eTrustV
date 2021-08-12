package com.coway.trust.biz.payment.invoice.service;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

public interface InvoiceAdjApplication {

    void insertInvoiceAdjAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);

}
