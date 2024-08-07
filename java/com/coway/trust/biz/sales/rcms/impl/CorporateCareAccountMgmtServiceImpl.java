package com.coway.trust.biz.sales.rcms.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.rcms.CorporateCareAccountMgmtService;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("corporateCareAccountMgmtService")
public class CorporateCareAccountMgmtServiceImpl extends EgovAbstractServiceImpl  implements CorporateCareAccountMgmtService{

	private static final Logger logger = LoggerFactory.getLogger(CorporateCareAccountMgmtServiceImpl.class);

	@Resource(name = "corporateCareAccountMgmtMapper")
	private CorporateCareAccountMgmtMapper corporateCareAccountMgmtMapper;

	@Override
	public EgovMap getDocNo(String docNoId){
		int tmp = Integer.parseInt(docNoId);
		String docNo = "";
		EgovMap selectDocNo = corporateCareAccountMgmtMapper.selectDocNo(docNoId);
		logger.debug("selectDocNo : {}",selectDocNo);
		String prefix = "";

		if(Integer.parseInt((String) selectDocNo.get("docNoId").toString()) == tmp){

			if(selectDocNo.get("c2") != null){
				prefix = (String) selectDocNo.get("c2");
			}else{
				prefix = "";
			}
			docNo = prefix.trim()+(String) selectDocNo.get("c1");
			//prefix = (selectDocNo.get("c2")).toString();
			logger.debug("prefix : {}",prefix);
			selectDocNo.put("docNo", docNo);
			selectDocNo.put("prefix", prefix);
		}
		return selectDocNo;
	}

	@Override
	public String getNextDocNo(String prefixNo,String docNo){
		String nextDocNo = "";
		int docNoLength=0;
		System.out.println("!!!"+prefixNo);
		if(prefixNo != null && prefixNo != ""){
			docNoLength = docNo.replace(prefixNo, "").length();
			docNo = docNo.replace(prefixNo, "");
		}else{
			docNoLength = docNo.length();
		}

		int nextNo = Integer.parseInt(docNo) + 1;
		nextDocNo = String.format("%0"+docNoLength+"d", nextNo);
		logger.debug("nextDocNo : {}",nextDocNo);
		return nextDocNo;
	}

	@Override
	public List<EgovMap> selectPortalList(Map<String, Object> params) throws Exception {

		return corporateCareAccountMgmtMapper.selectPortalList(params);
	}

	@Override
	public List<EgovMap> selectPortalNameList(Map<String, Object> params) throws Exception {

		return corporateCareAccountMgmtMapper.selectPortalNameList(params);
	}

	@Override
	public List<EgovMap> selectPortalStusList() throws Exception {

		return corporateCareAccountMgmtMapper.selectPortalStusList();
	}

	@Override
	public List<EgovMap> selectPICList() throws Exception {

		return corporateCareAccountMgmtMapper.selectPICList();
	}

	@Override
	public List<EgovMap> selectCareAccMgmtList(Map<String, Object> params) throws Exception {

		return corporateCareAccountMgmtMapper.selectCareAccMgmtList(params);
	}

	@Override
	public EgovMap selectPortalDetails(Map<String, Object> params) {
	    return corporateCareAccountMgmtMapper.selectPortalDetails(params);
	}

	 @SuppressWarnings("unchecked")
	@Override
	  public void addPortal(Map<String, Object> params) {
		 logger.debug("================addPortal - START ================");
		 logger.debug(params.toString());
		 EgovMap portalCode = getDocNo("197");
		 String nextDocNo = getNextDocNo("PP", CommonUtils.nvl(portalCode.get("docNo")));
		 portalCode.put("nextDocNo", nextDocNo);
		 corporateCareAccountMgmtMapper.updateDocNo((Map<String, Object>)portalCode);
		 params.put("portalCode", portalCode.get("docNo"));

		 corporateCareAccountMgmtMapper.addPortal(params);

	    logger.debug("================addPortal - END ================");
	  }

	 @Override
	  public void updatePortal(Map<String, Object> params) {
		 logger.debug("================updatePortal - START ================");
		 logger.debug(params.toString());

		 corporateCareAccountMgmtMapper.updatePortal(params);

		 logger.debug("================updatePortal - END ================");
	  }

	 @Override
	  public void updatePortalStatus(Map<String, Object> params) {
		 logger.debug("================updateDefPartStus - START ================");
		 logger.debug(params.toString());

		 corporateCareAccountMgmtMapper.updatePortalStatus(params);

		 logger.debug("================updateDefPartStus - END ================");
	  }

}
