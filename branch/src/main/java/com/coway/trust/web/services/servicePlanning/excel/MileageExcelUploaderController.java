package com.coway.trust.web.services.servicePlanning.excel;

import static com.coway.trust.cmmn.file.EgovFileUploadUtil.getUploadExcelFiles;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.excel.upload.ExcelUploadService;
import com.coway.trust.biz.services.servicePlanning.MileageCalculationService;
import com.coway.trust.cmmn.exception.ApplicationException;
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
	private ExcelUploadService excelUploadService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Value("${com.file.upload.path}")
	private String uploadDir;

	@RequestMapping(value = "/saveDCPMasterByExcel.do", method = RequestMethod.POST)
	public ResponseEntity readExcelCTArea(MultipartHttpServletRequest request, SessionVO sessionVO)
			throws IOException, InvalidFormatException {

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("excelFile");

		List<MileageExcelUploaderDataVO> vos = excelReadComponent.readExcelToList(multipartFile, true,
				MileageExcelUploaderDataVO::create);
		List<Map<String, Object>> updateList = new ArrayList<Map<String, Object>>();

		for (MileageExcelUploaderDataVO vo : vos) {
			LOGGER.debug("DETAIL >>>> MemberType : {}, Branch : {}, DCPFrom : {}, DCPTo : {}, Distance : {}",
					vo.getMemberType(), vo.getBranch(), vo.getDCPFrom(), vo.getDCPTo(), vo.getDistance());

			HashMap<String, Object> updateMap = new HashMap<String, Object>();

			updateMap.put("memType", vo.getMemberType());
			updateMap.put("brnchCode", vo.getBranch());
			updateMap.put("dcpFrom", vo.getDCPFrom());
			updateMap.put("dcpFromId", vo.getDCPFromID());
			updateMap.put("dcpTo", vo.getDCPTo());
			updateMap.put("dcpToId", vo.getDCPToID());
			updateMap.put("distance", vo.getDistance());

			// update datas
			updateList.add(updateMap);
		}

		// 파일 유효성 검사
		List<MileageExcelUploaderDataVO> vosValid = excelReadComponent.readExcelToList(multipartFile, false,
				MileageExcelUploaderDataVO::create);
		String memTypeValid = vosValid.get(0).getMemberType();
		String brnchCodeValid = vosValid.get(0).getBranch();
		String cityFromValid = vosValid.get(0).getCityFrom();
		String dcpFromValid = vosValid.get(0).getDCPFrom();
		String dcpFromIdValid = vosValid.get(0).getDCPFromID();
		LOGGER.debug("memTypeValid : " + memTypeValid + " / brnchCodeValid : " + brnchCodeValid + " / cityFromValid : "
				+ cityFromValid + " / dcpFromValid : " + dcpFromValid + " / dcpFromIdValid : " + dcpFromIdValid);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();

		if (memTypeValid.equals("Member Type") && brnchCodeValid.equals("Branch") && cityFromValid.equals("City From")
				&& dcpFromValid.equals("DCP From") && dcpFromIdValid.equals("DCP From ID")) {
			// updateCTSubGroupArea
			LOGGER.debug("udtList {}", updateList);
			mileageCalculationService.updateDCPMasterByExcel(updateList, sessionVO);

			message.setCode(AppConstants.SUCCESS);
			// //message.setData(totCnt);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		} else {
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}

		LOGGER.debug("message : " + message);

		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/saveDCPMasterByExcelLarge.do", method = RequestMethod.POST)
	public ResponseEntity saveDCPMasterByExcelLarge(MultipartHttpServletRequest request, SessionVO sessionVO)
			throws IOException {
		List<File> fileList = getUploadExcelFiles(request, uploadDir);

		String[] columns = { "no", "memType", "brnchCode", "cityFrom", "dcpFrom", "dcpFromId", "cityTo", "dcpTo",
				"dcpToId", "distance" };
		Map<String, Object> params = new HashMap<>();
		params.put("userId", sessionVO.getUserId());

		try {
			excelUploadService.updateDCPMasterByExcel(params, fileList.get(0), 2, columns);
		} catch (Exception e) {
			throw new ApplicationException(e, AppConstants.FAIL);
		} finally {
			for (File file : fileList) {
				file.delete();
			}
		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);

	}

}
