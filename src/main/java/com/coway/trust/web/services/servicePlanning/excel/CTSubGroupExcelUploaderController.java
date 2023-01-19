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
import com.coway.trust.biz.services.servicePlanning.CTSubGroupListService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.excel.ExcelReadComponent;
import com.coway.trust.util.CommonUtils;

@RestController
@RequestMapping("/services/serviceGroup/excel")
public class CTSubGroupExcelUploaderController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CTSubGroupExcelUploaderController.class);

	@Autowired
	private ExcelReadComponent excelReadComponent;

	@Autowired
	private CTSubGroupListService CTSubGroupListService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/updateCTAreaByExcel.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> readExcelCTArea(MultipartHttpServletRequest request) throws IOException, InvalidFormatException {
		LOGGER.debug("radioVal : {}", request.getParameter("radioVal"));

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("excelFile");

		List<CTSubGroupAreaExcelUploaderDataVO> vos = excelReadComponent.readExcelToList(multipartFile, true, CTSubGroupAreaExcelUploaderDataVO::create);
		List<Map<String, Object>> updateList = new ArrayList<Map<String, Object>>();

		for (CTSubGroupAreaExcelUploaderDataVO vo : vos)
		{
			LOGGER.debug("DETAIL >>>> AreaID : {}, svcWeek : {}, priodFrom : {}, priodTo : {}", vo.getAreaID(), vo.getServiceWeek(), vo.getPriodFrom(), vo.getPriodTo());

			HashMap<String, Object> updateMap = new HashMap<String, Object>();

			updateMap.put("areaId",vo.getAreaID());
			updateMap.put("area",vo.getArea());
			updateMap.put("city",vo.getCity());
			updateMap.put("postcode",vo.getPostalCode());
			updateMap.put("state",vo.getState());
			updateMap.put("locType",vo.getLocalType());
			updateMap.put("svcWeek",vo.getServiceWeek());
			updateMap.put("ctSubGrp",vo.getSubGroup());
			updateMap.put("priodFrom",vo.getPriodFrom());
			updateMap.put("priodTo",vo.getPriodTo());

			// update datas
			updateList.add(updateMap);
		}

		// 파일 유효성 검사
		List<CTSubGroupAreaExcelUploaderDataVO> vosValid = excelReadComponent.readExcelToList(multipartFile, false, CTSubGroupAreaExcelUploaderDataVO::create);
		String localTypeValid = vosValid.get(0).getLocalType();
		String serviceWeekValid = vosValid.get(0).getServiceWeek();
		String priodFromValid = vosValid.get(0).getPriodFrom();
		String priodToValid = vosValid.get(0).getPriodTo();
		LOGGER.debug("localTypeValid : " + localTypeValid + " / serviceWeekValid : " + serviceWeekValid
										+ " / priodFromValid : " + priodFromValid + " / priodToValid : " + priodToValid);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();

		if (localTypeValid.equals("Local Type") && serviceWeekValid.equals("Service Week")
				&& priodFromValid.equals("Priod From") && priodToValid.equals("Priod To")) {
			//updateCTSubGroupArea
			LOGGER.debug("udtList {}", updateList);
			CTSubGroupListService.updateCTAreaByExcel(updateList);

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

	/**
	 * CT Sub Group By Excel Upload
	 * @Author KR-SH
	 * @Date 2019. 11. 29.
	 * @param request
	 * @return
	 * @throws IOException
	 * @throws InvalidFormatException
	 */
	@RequestMapping(value = "/updateCTSubGroupByExcel.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> readExcelCTSubGroup(MultipartHttpServletRequest request, SessionVO sessionVO) throws IOException, InvalidFormatException {
		// 결과 만들기
		ReturnMessage message = new ReturnMessage();

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("excelFile");

		List<CTSubGroupExcelUploaderDataVO> vos = excelReadComponent.readExcelToList(multipartFile, true, CTSubGroupExcelUploaderDataVO::create);
		List<Map<String, Object>> updateList = new ArrayList<Map<String, Object>>();
		HashMap<String, Object> updateMap = null;
		String memId = "";
		String ctSubGrp = "";
		String acSubGrp = "";

		for (CTSubGroupExcelUploaderDataVO vo : vos) {
			memId = CommonUtils.nvl(vo.getMemId());
			ctSubGrp = CommonUtils.nvl(vo.getCTSubGroup());
			acSubGrp = CommonUtils.nvl(vo.getACSubGroup());

			// 파일 유효성 검사.
			if("".equals(memId) || ("".equals(ctSubGrp) && "".equals(acSubGrp))) {
				message.setCode(AppConstants.FAIL);
				message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
				return ResponseEntity.ok(message);

			} else {
				updateMap = new HashMap<String, Object>();

				updateMap.put("memId", memId);
				if(!"".equals(acSubGrp)){
					updateMap.put("acSubGrp", acSubGrp);
				}else{
					updateMap.put("ctSubGrp", ctSubGrp);
				}

				// update datas
				updateList.add(updateMap);
			}
		}
		message = CTSubGroupListService.saveCTSubGroup(updateList, sessionVO);

		return ResponseEntity.ok(message);
	}

}
