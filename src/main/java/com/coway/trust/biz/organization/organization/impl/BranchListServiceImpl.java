package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.organization.BranchListService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("branchListService")
public class BranchListServiceImpl extends EgovAbstractServiceImpl implements BranchListService{

	@SuppressWarnings("unused")
	private static final Logger logger = LoggerFactory.getLogger(MemberEventServiceImpl.class);

	@Resource(name = "branchListMapper")
	private BranchListMapper branchListMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;


	@Override
	public List<EgovMap> selectBranchList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return branchListMapper.selectBranchList(params);
	}


	@Override
	public EgovMap getBranchDetailPop(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return branchListMapper.getBranchDetailPop(params);
	}


	@Override
	public List<EgovMap> getBranchType(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return branchListMapper.getBranchType(params);
	}

	@Override
	public  int    branchListUpdate(Map<String, Object> params) {



		return branchListMapper.branchListUpdate(params);
	}


	@Override
	public int branchListInsert(Map<String, Object> params) {


		return branchListMapper.branchListInsert(params);
	}

	@Override
	public List<EgovMap> getStateList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return branchListMapper.getStateList(params);
	}


	@Override
	public List<EgovMap> getAreaList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return branchListMapper.getAreaList(params);
	}


	@Override
	public List<EgovMap> getPostcodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return branchListMapper.getPostcodeList(params);
	}

	@Override
	public EgovMap getBranchAddrDetail(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return branchListMapper.getBranchAddrDetail(params);
	}

	@Override
	public List<EgovMap> selectBranchCdInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return branchListMapper.selectBranchCdInfo(params);
	}


}
