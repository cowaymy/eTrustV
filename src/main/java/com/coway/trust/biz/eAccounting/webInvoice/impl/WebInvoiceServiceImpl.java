package com.coway.trust.biz.eAccounting.webInvoice.impl;

import java.util.Collection;
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

import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("webInvoiceService")
public class WebInvoiceServiceImpl implements WebInvoiceService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(SampleServiceImpl.class);

	@Value("${app.name}")
	private String appName;
	
	@Resource(name = "webInvoiceMapper")
	private WebInvoiceMapper webInvoiceMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Override
	public List<EgovMap> selectWebInvoiceList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectWebInvoiceList(params);
	}
	
	@Override
	public List<EgovMap> selectApproveList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectApproveList(params);
	}

	@Override
	public EgovMap selectWebInvoiceInfo(String clmNo) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectWebInvoiceInfo(clmNo);
	}
	
	@Override
	public List<EgovMap> selectAppvInfoAndItems(String appvPrcssNo) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectAppvInfoAndItems(appvPrcssNo);
	}

	@Override
	public List<EgovMap> selectWebInvoiceItems(String clmNo) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectWebInvoiceItems(clmNo);
	}
	
	@Override
	public List<EgovMap> selectAttachList(String atchFileGrpId) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectAttachList(atchFileGrpId);
	}
	
	@Override
	public EgovMap selectAttachmentInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectAttachmentInfo(params);
	}

	@Override
	public void insertWebInvoiceInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		webInvoiceMapper.insertWebInvoiceInfo(params);
	}
	
	@Override
	public void insertWebInvoiceDetail(Map<String, Object> params) {
		// TODO Auto-generated method stub
		webInvoiceMapper.insertWebInvoiceDetail(params);
	}
	
	@Override
	public void updateWebInvoiceInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		webInvoiceMapper.updateWebInvoiceInfo(params);
	}

	@Override
	public void updateWebInvoiceDetail(Map<String, Object> params) {
		// TODO Auto-generated method stub
		webInvoiceMapper.updateWebInvoiceDetail(params);
	}
	
	@Override
	public void insertApproveManagement(Map<String, Object> params) {
		// TODO Auto-generated method stub
		webInvoiceMapper.insertApproveManagement(params);
	}

	@Override
	public void insertApproveLineDetail(Map<String, Object> params) {
		// TODO Auto-generated method stub
		webInvoiceMapper.insertApproveLineDetail(params);
	}

	@Override
	public void insertApproveItems(Map<String, Object> params) {
		// TODO Auto-generated method stub
		webInvoiceMapper.insertApproveItems(params);
	}
	
	@Override
	public void updateAppvPrcssNo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		webInvoiceMapper.updateAppvPrcssNo(params);
	}

	@Override
	public List<EgovMap> selectSupplier(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectSupplier(params);
	}

	@Override
	public List<EgovMap> selectCostCenter(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectCostCenter(params);
	}
	
	@Override
	public List<EgovMap> selectTaxCodeWebInvoiceFlag() {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectTaxCodeWebInvoiceFlag();
	}
	
	@Override
	public String selectNextClmNo() {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectNextClmNo();
	}

	@Override
	public int selectNextClmSeq(String clmNo) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectNextClmSeq(clmNo);
	}

	@Override
	public String selectNextAppvPrcssNo() {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectNextAppvPrcssNo();
	}

	@Override
	public int selectNextAppvItmSeq(String appvPrcssNo) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectNextAppvItmSeq(appvPrcssNo);
	}
	
	
	
	

}
