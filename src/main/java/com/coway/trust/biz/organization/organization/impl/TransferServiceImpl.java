package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.organization.TransferService;
import com.coway.trust.web.organization.organization.TransferController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("transferService")
public class TransferServiceImpl extends EgovAbstractServiceImpl implements TransferService{
	private static final Logger logger = LoggerFactory.getLogger(TransferController.class);
	
	@Resource(name = "transferMapper")
	private TransferMapper transferMapper;
	
	@Override
	public List<EgovMap> selectMemberLevel(Map<String, Object> params) {
		return transferMapper.selectMemberLevel(params);
	}
	@Override
	public List<EgovMap> selectFromTransfer(Map<String, Object> params) {
		return transferMapper.selectFromTransfer(params);
	}
	
	@Override
	public List<EgovMap> selectTransferList(Map<String, Object> params) {
		return transferMapper.selectTransferList(params);
	}
	
}
