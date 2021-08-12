package com.coway.trust.web.scm.excel;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.scm.ScmMasterMngMentService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.excel.ExcelReadComponent;

@RestController
@RequestMapping("/scm/excel")
public class BIzPlanExcelUploaderController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BIzPlanExcelUploaderController.class);

	@Autowired
	private ExcelReadComponent excelReadComponent;   
	@Autowired
	private ScmMasterMngMentService scmMastMngService;;   
	
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/upload", method = RequestMethod.POST)
	public ResponseEntity readExcel(MultipartHttpServletRequest request, SessionVO sessionVO) throws IOException, InvalidFormatException
	{

		LOGGER.debug("Excel_param01 : {}", request.getParameter("paramTeam"));
		LOGGER.debug("Excel_param02 : {}", request.getParameter("paramYear"));
		LOGGER.debug("Excel_param02 : {}", request.getParameter("paramVer"));

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("excelFile");

		List<BizPlanExcelUploaderDataVO> vos = excelReadComponent.readExcelToList(multipartFile, true, BizPlanExcelUploaderDataVO::create);
		List<Map<String, Object>> detailList = new ArrayList<Map<String, Object>>();

		for (BizPlanExcelUploaderDataVO vo : vos) 
		{
			LOGGER.debug("DETAIL >>>> PlanId : {}, stockCode : {}", vo.getPlanID(), vo.getSTOCK_CODE());
			
			HashMap<String, Object> detailMap = new HashMap<String, Object>();
			
			detailMap.put("creator", sessionVO.getUserId());
			detailMap.put("updator", sessionVO.getUserId());
			detailMap.put("planId",vo.getPlanID());
			detailMap.put("stockCode",vo.getSTOCK_CODE());
			detailMap.put("team"  ,vo.getTEAM());
			detailMap.put("m01"   ,vo.getM01());
			detailMap.put("m02"   ,vo.getM02());
			detailMap.put("m03"   ,vo.getM03());
			detailMap.put("m04"   ,vo.getM04());
			detailMap.put("m05"   ,vo.getM05());
			detailMap.put("m06"   ,vo.getM06());
			detailMap.put("m07"   ,vo.getM07());
			detailMap.put("m08"   ,vo.getM08());
			detailMap.put("m09"   ,vo.getM09());
			detailMap.put("m10"   ,vo.getM10());
			detailMap.put("m11"   ,vo.getM11());
			detailMap.put("m12"   ,vo.getM12());
			
			// detail datas
			detailList.add(detailMap);
		}
		
		//Master setting
		Map<String, Object> masterMap = new HashMap<String, Object>();
	    
		masterMap.put("scmYearCbBox", request.getParameter("paramYear"));
		masterMap.put("scmTeamCbBox",  request.getParameter("paramTeam"));
		masterMap.put("scmPeriodCbBox",  request.getParameter("paramVer"));
		masterMap.put("crtUserId", sessionVO.getUserId());
		masterMap.put("updUserId", sessionVO.getUserId());
		
		//insertBizPlanMaster
		int totCnt = scmMastMngService.saveLoadExcel(masterMap, detailList);
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);

	}
}
