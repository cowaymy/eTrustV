package com.coway.trust.biz.services.codeMgmt.impl;

import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.services.codeMgmt.codeMgmtService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("codeMgmtService")
public class codeMgmtServiceImpl implements codeMgmtService{

	private static final Logger logger = LoggerFactory.getLogger(codeMgmtServiceImpl.class);

	@Resource(name = "CodeMgmtMapper")
	private codeMgmtMapper codeMgmtMapper;

	@Override
    public List<EgovMap> selectCodeCatList( Map<String, Object> params )
    {
        return codeMgmtMapper.selectCodeCatList( params );
    }

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
	    return codeMgmtMapper.chkProductAvail(params.get("prodCode").toString());
	}

	@Override
	public List<EgovMap> chkDupReasons(Map<String, Object> params) {
		EgovMap typeCode = codeMgmtMapper.getTypeCode(params.get("codeCtgry").toString());
		params.put("reasonCodeId", typeCode.get("code").toString());

		logger.debug("aaaaa111====" + params.toString());
		logger.debug("aaaaa222====" + params.get("reasonCodeId").toString());
	    return codeMgmtMapper.chkDupReasons(params);
	}

	@Override
	public List<EgovMap> chkDupDefectCode(Map<String, Object> params) {
		EgovMap typeCode = codeMgmtMapper.getTypeCode(params.get("codeCtgry").toString());
		params.put("defectType", typeCode.get("code").toString());
		//logger.debug("aaaaa1====" + typeCode.get("code").toString());

	    return codeMgmtMapper.chkDupDefectCode(params);
	}

	@Override
	public EgovMap selectSvcCodeInfo(Map<String, Object> params) {

		//get svc code type
	    return codeMgmtMapper.selectSvcCodeInfo(params);
	}

	 @Override
	  public ReturnMessage saveNewCode(Map<String, Object> params, SessionVO sessionVO)
	      throws ParseException {
		 Map<String, Object> resultValue = new HashMap<String, Object>();
		    ReturnMessage message = new ReturnMessage();

            Map<String, Object> saveParam = new HashMap<String, Object>();
            saveParam = (Map<String, Object>) params.get("newCodeM");

            saveParam.put("updator", sessionVO.getUserId());
            saveParam.put("creator", sessionVO.getUserId());
		    //get Type Code
		    EgovMap typeCode;
		    EgovMap defectId;

		    if (saveParam.get("codeCtgry").toString().equals("19")) { //product setting　SYS0026M
		    	codeMgmtMapper.updateProductSetting(params);
		    }else {
		    	typeCode = codeMgmtMapper.getTypeCode(saveParam.get("codeCtgry").toString());
		    	params.put("defectCode", typeCode.get("code").toString());
		    	defectId = codeMgmtMapper.getDefectId();
		    	params.put("defectId", defectId.get("defectId").toString());

		    	if (Integer.parseInt(params.get("codeCtgry").toString()) >=10 && Integer.parseInt(params.get("codeCtgry").toString()) <=16){ //SYS0032M
			    	codeMgmtMapper.addASReasons(params); //sequence for sys0032m
			    }else if (saveParam.get("codeCtgry").toString().equals("17") || saveParam.get("codeCtgry").toString().equals("18")){ //SVC0142D
			    	codeMgmtMapper.addSVC0142D(params); //sequence for SVC0142D
			    }else{ //SYS0100M
			    	if (saveParam.get("codeCtgry").toString().equals("1") || saveParam.get("codeCtgry").toString().equals("3")
				    		|| saveParam.get("codeCtgry").toString().equals("5") || saveParam.get("codeCtgry").toString().equals("7")){ //SMALL

			    		defectId = codeMgmtMapper.getDefectIdParent(saveParam);

			    		try{
				    		params.put("defectGrp", defectId.get("defectGrp").toString());

			    		}catch (Exception e){
							throw new ApplicationException(AppConstants.FAIL, saveParam.get("svcLargeCode") + " is not available in system");
			    		}
				    	codeMgmtMapper.addDefectCodesSmall(params);
			    	}else{
				    	codeMgmtMapper.addDefectCodes(params);
			    	}

			    }
		    }

		 return message;
	 }

	 @Override
	  public ReturnMessage updateSvcCode(Map<String, Object> params, SessionVO sessionVO)
	      throws ParseException {
		 Map<String, Object> resultValue = new HashMap<String, Object>();
		    ReturnMessage message = new ReturnMessage();

		    //get Type Code
		    EgovMap typeCode;
		    logger.debug("params====" + params.toString());

		    if (params.get("codeCtgry").toString().equals("19")) { //product setting　SYS0026M
		    	codeMgmtMapper.updateProductSetting(params);
		    }else {
		    	typeCode = codeMgmtMapper.getTypeCode(params.get("codeCtgry").toString());
		    	params.put("defectCode", typeCode.toString());

		    	if (Integer.parseInt(params.get("codeCtgry").toString()) >=10 && Integer.parseInt(params.get("codeCtgry").toString()) <=16){ //SYS0032M
			    	codeMgmtMapper.updateASReasons(params); //sequence for sys0032m
			    }else if (params.get("codeCtgry").toString().equals("17") || params.get("codeCtgry").toString().equals("18")){ //SVC0142D
			    	codeMgmtMapper.updateSVC0142D(params); //sequence for SVC0142D
			    }else{ //SYS0100M
			    	codeMgmtMapper.updateDefectCodes(params); //sequence for sys0100m
			    }
		    }

		 return message;
	 }

	 @Override
	  public void updateCodeStus(Map<String, Object> params) {
		 logger.debug("================updateCodeStus - START ================");
		 logger.debug(params.toString());
		 logger.debug(params.get("codeCatId").toString());

		 if(Integer.parseInt(params.get("codeCatId").toString()) >=10 && Integer.parseInt(params.get("codeCatId").toString()) <=16){ //SYS0032M
			 logger.debug("================sys32 - START ================");
			 codeMgmtMapper.updateCodeStusSYS32(params);
		 }else if(params.get("codeCatId").toString().equals("17") || params.get("codeCatId").toString().equals("18")){ //SVC0142D
			 logger.debug("================sys13 - START ================");
			 codeMgmtMapper.updateCodeStusSVC142(params);
		 }else{
			 logger.debug("================sys100 - START ================");
			 codeMgmtMapper.updateCodeStusSYS100(params);
		 }

		 logger.debug("================updateCodeStus - END ================");
	  }
}
