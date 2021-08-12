package com.coway.trust.web.organization.organization.excel;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import com.coway.trust.biz.organization.organization.SessionCapacityListService;
import com.coway.trust.biz.services.servicePlanning.MileageCalculationService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.excel.ExcelReadComponent;

@RestController
@RequestMapping("/organization/excel")
public class CapacityExcelUploaderController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CapacityExcelUploaderController.class);

	@Autowired
	private ExcelReadComponent excelReadComponent;   
	
	@Autowired
	private SessionCapacityListService sessionCapacityListService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/saveCapacityByExcel.do", method = RequestMethod.POST)
	public ResponseEntity readExcelCTArea(MultipartHttpServletRequest request, SessionVO sessionVO) throws IOException, InvalidFormatException
	{

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("excelFile");

		List<CapacityExcelUploaderDataVO> vos = excelReadComponent.readExcelToList(multipartFile, 2, CapacityExcelUploaderDataVO::create);
		List<Map<String, Object>> updateList = new ArrayList<Map<String, Object>>();

		for (CapacityExcelUploaderDataVO vo : vos) 
		{
			LOGGER.debug("DETAIL >>>> morngSesionAs : {}, morngSesionIns : {}, morngSesionRtn : {}", 
												vo.getMorngSesionAs(), vo.getMorngSesionIns(), vo.getMorngSesionRtn());
			
			HashMap<String, Object> updateMap = new HashMap<String, Object>();
			
			updateMap.put("codeId",vo.getBranch1());
			updateMap.put("memId",vo.getCT1());
			updateMap.put("morngSesionAs",vo.getMorngSesionAs());
			updateMap.put("morngSesionIns",vo.getMorngSesionIns());
			updateMap.put("morngSesionRtn",vo.getMorngSesionRtn());
			updateMap.put("aftnonSesionAs",vo.getAftnonSesionAs());
			updateMap.put("aftnonSesionIns",vo.getAftnonSesionIns());
			updateMap.put("aftnonSesionRtn",vo.getAftnonSesionRtn());
			updateMap.put("evngSesionAs",vo.getEvngSesionAs());
			updateMap.put("evngSesionIns",vo.getEvngSesionIns());
			updateMap.put("evngSesionRtn",vo.getEvngSesionRtn());
			
			// update datas
			updateList.add(updateMap);
		}
		
		// 파일 유효성 검사
		List<CapacityExcelUploaderDataVO> vosValid = excelReadComponent.readExcelToList(multipartFile, 1, CapacityExcelUploaderDataVO::create);
		String morngSesionAsValid = vosValid.get(0).getMorngSesionAs();
		String morngSesionInsValid = vosValid.get(0).getMorngSesionIns();
		String morngSesionRtnValid = vosValid.get(0).getMorngSesionRtn();
		LOGGER.debug("morngSesionAsValid : " + morngSesionAsValid + " / morngSesionInsValid : " + morngSesionInsValid + " / morngSesionRtnValid : " + morngSesionRtnValid);
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		
		if (morngSesionAsValid.equals("AS") && morngSesionInsValid.equals("INS") && morngSesionRtnValid.equals("RTN")) {
			//updateCTSubGroupArea
//			LOGGER.debug("udtList {}", updateList);
			sessionCapacityListService.updateCapacityByExcel(updateList,sessionVO);
			sessionCapacityListService.updateCTMCapacityByExcel(updateList,sessionVO);
			sessionCapacityListService.deleteCapacityByExcel(updateList,sessionVO);
			
			message.setCode(AppConstants.SUCCESS);
//			//message.setData(totCnt);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		} else {
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
		
		LOGGER.debug("message : "+message);
		
		return ResponseEntity.ok(message);

	}
	
}
