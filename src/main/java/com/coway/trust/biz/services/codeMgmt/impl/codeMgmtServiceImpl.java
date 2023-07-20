package com.coway.trust.biz.services.codeMgmt.impl;

import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.codeMgmt.codeMgmtService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("codeMgmtService")
public class codeMgmtServiceImpl implements codeMgmtService{

	private static final Logger logger = LoggerFactory.getLogger(codeMgmtServiceImpl.class);

	@Resource(name = "CodeMgmtMapper")
	private codeMgmtMapper codeMgmtMapper;

	@Override
	public EgovMap selectCodeMgmtInfo(Map<String, Object> params) {
	    return codeMgmtMapper.selectCodeMgmtInfo(params);
	}

	@Override
	public List<EgovMap> selectCodeMgmtList(Map<String, Object> params) {
		return codeMgmtMapper.selectCodeMgmtList(params);
	}

	@Override
	public List<EgovMap> chkProductAvail(Map<String, Object> params) {
	    return codeMgmtMapper.chkProductAvail(params);
	}

	@Override
	public List<EgovMap> chkDupReasons(Map<String, Object> params) {
		EgovMap typeCode = codeMgmtMapper.getTypeCode(params.get("codeCtgry").toString());
		params.put("reasonCodeId", typeCode.toString());

	    return codeMgmtMapper.chkDupReasons(params);
	}

	@Override
	public EgovMap selectSvcCodeInfo(Map<String, Object> params) {

		//get svc code type
	    return codeMgmtMapper.selectSvcCodeInfo(params);
	}

	@Override
	public List<EgovMap> chkDupDefectCode(Map<String, Object> params) {
		EgovMap typeCode = codeMgmtMapper.getTypeCode(params.get("codeCtgry").toString());
		params.put("defectType", typeCode.toString());

	    return codeMgmtMapper.chkDupDefectCode(params);
	}

	 @Override
	  public ReturnMessage saveNewCode(Map<String, Object> params, SessionVO sessionVO)
	      throws ParseException {
		 Map<String, Object> resultValue = new HashMap<String, Object>();
		    ReturnMessage message = new ReturnMessage();

            Map<String, Object> saveParam = new HashMap<String, Object>();
            saveParam = (Map<String, Object>) params.get("sForm");

            saveParam.put("updator", sessionVO.getUserId());
            saveParam.put("creator", sessionVO.getUserId());
		    //get Type Code
		    EgovMap typeCode;

		    logger.debug("aaaaa====" + saveParam.toString());

		    if (saveParam.get("codeCtgry").toString() == "7296") { //product setting　SYS0026M
		    	codeMgmtMapper.updateProductSetting(params);
		    }else {
		    	typeCode = codeMgmtMapper.getTypeCode(saveParam.get("codeCtgry").toString());
		    	saveParam.put("defectCode", typeCode.toString());

		    	if (saveParam.get("codeCtgry").toString() != "7311" || saveParam.get("codeCtgry").toString() != "7312"
		    		|| saveParam.get("codeCtgry").toString() != "7313" || saveParam.get("codeCtgry").toString() != "7314"){ //SYS0032M
			    	codeMgmtMapper.addASReasons(params); //sequence for sys0032m
			    }else if (saveParam.get("codeCtgry").toString() != "7319" || saveParam.get("codeCtgry").toString() != "7320"){ //SYS0013M
			    	codeMgmtMapper.addSYS0013M(params); //sequence for sys0032m
			    }else{ //SYS0100M
			    	codeMgmtMapper.addDefectCodes(params); //sequence for sys0100m
			    }
		    }

		 return message;
	 }

	 @Override
	  public void updateCodeStus(Map<String, Object> params) {
		 logger.debug("================updateCodeStus - START ================");
		 logger.debug(params.toString());
		 logger.debug(params.get("codeCatId").toString());

		 if(params.get("codeCatId").toString().equals("7311") || params.get("codeCatId").toString().equals("7312")
				 || params.get("codeCatId").toString().equals("7313") || params.get("codeCatId").toString().equals("7314")){ //SYS0032M
			 logger.debug("================sys32 - START ================");
			 codeMgmtMapper.updateCodeStusSYS32(params);
		 }else if(params.get("codeCatId").toString().equals("7319") || params.get("codeCatId").toString().equals("7320")){ //SYS0013M
			 logger.debug("================sys13 - START ================");
			 codeMgmtMapper.updateCodeStusSYS13(params);
		 }else{
			 logger.debug("================sys100 - START ================");
			 codeMgmtMapper.updateCodeStusSYS100(params);
		 }

		 logger.debug("================updateCodeStus - END ================");
	  }
}
