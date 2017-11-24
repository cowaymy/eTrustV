package com.coway.trust.web.services.servicePlanning.excel;

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
import com.coway.trust.biz.services.servicePlanning.MileageCalculationService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.excel.ExcelReadComponent;

@RestController
@RequestMapping("/services/mileageCileage/excel")
public class MileageExcelUploaderController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MileageExcelUploaderController.class);

	@Autowired
	private ExcelReadComponent excelReadComponent;   
	
	@Autowired
	private MileageCalculationService mileageCalculationService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/saveDCPMasterByExcel.do", method = RequestMethod.POST)
	public ResponseEntity readExcelCTArea(MultipartHttpServletRequest request, SessionVO sessionVO) throws IOException, InvalidFormatException
	{

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("excelFile");

		List<MileageExcelUploaderDataVO> vos = excelReadComponent.readExcelToList(multipartFile, true, MileageExcelUploaderDataVO::create);
		List<Map<String, Object>> updateList = new ArrayList<Map<String, Object>>();

		for (MileageExcelUploaderDataVO vo : vos) 
		{
			LOGGER.debug("DETAIL >>>> MemberType : {}, Branch : {}, DCPFrom : {}, DCPTo : {}, Distance : {}", 
												vo.getMemberType(), vo.getBranch(), vo.getDCPFrom(), vo.getDCPTo(), vo.getDistance());
			
			HashMap<String, Object> updateMap = new HashMap<String, Object>();
			
			updateMap.put("memType",vo.getMemberType());
			updateMap.put("brnchCode",vo.getBranch());
			updateMap.put("dcpFrom",vo.getDCPFrom());
			updateMap.put("dcpTo",vo.getDCPTo());
			updateMap.put("distance",vo.getDistance());
			updateMap.put("memType1",vo.getMemType1());
			updateMap.put("brnchCode1",vo.getBrnchCode1());
			updateMap.put("dcpFrom1",vo.getDcpFrom1());
			updateMap.put("dcpTo1",vo.getDcpTo1());
			updateMap.put("distance1",vo.getDistance1());
			
			// update datas
			updateList.add(updateMap);
		}
		
		// 파일 유효성 검사
		List<MileageExcelUploaderDataVO> vosValid = excelReadComponent.readExcelToList(multipartFile, false, MileageExcelUploaderDataVO::create);
		String memType1Valid = vosValid.get(0).getMemType1();
		String brnchCode1Valid = vosValid.get(0).getBrnchCode1();
		String dcpFrom1Valid = vosValid.get(0).getDcpFrom1();
		String dcpTo1Valid = vosValid.get(0).getDcpTo1();
		String distance1Valid = vosValid.get(0).getDistance1();
		LOGGER.debug("memType1Valid : " + memType1Valid + " / brnchCode1Valid : " + brnchCode1Valid
								+ " / dcpFrom1Valid : " + dcpFrom1Valid + " / dcpTo1Valid : " + dcpTo1Valid + " / distance1Valid : " + distance1Valid);
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		
		if (memType1Valid.equals("memType1") && brnchCode1Valid.equals("brnchCode1") 
				&& dcpFrom1Valid.equals("dcpFrom1") && dcpTo1Valid.equals("dcpTo1") && distance1Valid.equals("distance1")) {
			//updateCTSubGroupArea
			LOGGER.debug("udtList {}", updateList);
			mileageCalculationService.updateDCPMasterByExcel(updateList,sessionVO);
			
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
