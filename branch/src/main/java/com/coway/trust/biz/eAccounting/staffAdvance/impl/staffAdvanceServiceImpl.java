package com.coway.trust.biz.eAccounting.staffAdvance.impl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.eAccounting.staffAdvance.staffAdvanceService;
import com.coway.trust.biz.eAccounting.webInvoice.impl.WebInvoiceMapper;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("staffAdvanceService")
public class staffAdvanceServiceImpl implements staffAdvanceService {

    @Resource(name = "staffAdvanceMapper")
    private staffAdvanceMapper staffAdvanceMapper;

    @Resource(name = "webInvoiceMapper")
    private WebInvoiceMapper webInvoiceMapper;

    @Override
    public List<EgovMap> selectAdvanceList(Map<String, Object> params) {
        return staffAdvanceMapper.selectAdvanceList(params);
    }

    @Override
    public EgovMap getAdvConfig(Map<String, Object> params) {
        return staffAdvanceMapper.getAdvConfig(params);
    }

    @Override
    public EgovMap getRqstInfo(Map<String, Object> params) {
        return staffAdvanceMapper.getRqstInfo(params);
    }

    @Override
    public String selectNextClmNo(Map<String, Object> params) {
        return staffAdvanceMapper.selectNextClmNo(params);
    }

    @Override
    public void insertRequest(Map<String, Object> params) {
        staffAdvanceMapper.insertRequest(params);
    }

    @Override
    public void editDraftRequestM(Map<String, Object> params) {
        staffAdvanceMapper.editDraftRequestM(params);
    }

    @Override
    public void editDraftRequestD(Map<String, Object> params) {
        staffAdvanceMapper.editDraftRequestD(params);
    }

    @Override
    public void insertTrvDetail(Map<String, Object> params) {
        staffAdvanceMapper.insertTrvDetail(params);
    }

    @Override
    public void insertApproveManagement(Map<String, Object> params) {
        webInvoiceMapper.insertApproveManagement(params);
    }

    @Override
    public void insertApproveLineDetail(Map<String, Object> params) {
        webInvoiceMapper.insertApproveLineDetail(params);
    }

    @Override
    public void insMissAppr(Map<String, Object> params) {
        webInvoiceMapper.insMissAppr(params);
    }

    @Override
    public EgovMap getClmDesc(Map<String, Object> params) {
        return webInvoiceMapper.getClmDesc(params);
    }

    @Override
    public EgovMap getNtfUser(Map<String, Object> params) {
        return webInvoiceMapper.getNtfUser(params);
    }

    @Override
    public void insertNotification(Map<String, Object> params) {
        webInvoiceMapper.insertNotification(params);
    }

    @Override
    public void updateAdvanceReqInfo(Map<String, Object> params) {
        staffAdvanceMapper.updateAdvanceReqInfo(params);
    }

    @Override
    public EgovMap getRefDtls(Map<String, Object> params) {
        return staffAdvanceMapper.getRefDtls(params);
    }

    @Override
    public void insertRefund(Map<String, Object> params) {
        staffAdvanceMapper.insertRefund(params);
    }

    @Override
    public void insertAppvDetails(Map<String, Object> params) {
        staffAdvanceMapper.insertAppvDetails(params);
    }

    @Override
    public void updateAdvRequest(Map<String, Object> params) {
        staffAdvanceMapper.updateAdvRequest(params);
    }

    @Override
    public EgovMap getAdvType(Map<String, Object> params) {
        return staffAdvanceMapper.getAdvType(params);
    }

    @Override
    public List<EgovMap> selectAppvInfoAndItems(Map<String, Object> params) {
        return staffAdvanceMapper.selectAppvInfoAndItems(params);
    }

    @Override
    public EgovMap getAdvClmInfo(Map<String, Object> params) {
        return staffAdvanceMapper.getAdvClmInfo(params);
    }

    @Override
    public void updateTotal(Map<String, Object> params) {
        staffAdvanceMapper.updateTotal(params);
    }
}
