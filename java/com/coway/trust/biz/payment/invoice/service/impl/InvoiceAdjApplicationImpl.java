package com.coway.trust.biz.payment.invoice.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.payment.invoice.service.InvoiceAdjApplication;

@Service("InvoiceAdjApplication")
public class InvoiceAdjApplicationImpl implements InvoiceAdjApplication {

    @Autowired
    private FileService fileService;

    @Override
    public void insertInvoiceAdjAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params) {
        int fileGroupKey = fileService.insertFiles(list, type, (Integer) params.get("userId"));
        params.put("fileGroupKey", fileGroupKey);
    }

}
