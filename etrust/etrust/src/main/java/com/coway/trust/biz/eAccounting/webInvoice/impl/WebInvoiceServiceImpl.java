package com.coway.trust.biz.eAccounting.webInvoice.impl;

import java.util.List;
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
	public EgovMap selectWebInvoiceInfo(String clmNo) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectWebInvoiceInfo(clmNo);
	}
	
	@Override
	public List<EgovMap> selectWebInvoiceItems(String clmNo) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectWebInvoiceItems(clmNo);
	}
	
	@Override
	public List<EgovMap> selectWebInvoiceAttachList(int atchFileGrpId) {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectWebInvoiceAttachList(atchFileGrpId);
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
	public int selectNextClmSeq() {
		// TODO Auto-generated method stub
		return webInvoiceMapper.selectNextClmSeq();
	}
	
	
	
	

}
