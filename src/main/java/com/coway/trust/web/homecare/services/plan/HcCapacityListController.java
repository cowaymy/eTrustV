package com.coway.trust.web.homecare.services.plan;

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
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.services.plan.HcCapacityListService;
import com.coway.trust.biz.organization.organization.SessionCapacityListService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.excel.ExcelReadComponent;
import com.coway.trust.web.homecare.HomecareConstants;
import com.coway.trust.web.organization.organization.excel.CapacityExcelUploaderDataVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcCapacityListController.java
 * @Description : Homecare Capacity Management Controller
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 18.   KR-SH        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/homecare/services/plan")
public class HcCapacityListController {
	private static final Logger logger = LoggerFactory.getLogger(HcCapacityListController.class);

	@Resource(name = "hcCapacityListService")
	private HcCapacityListService hcCapacityListService;

	@Resource(name = "sessionCapacityListService")
	private SessionCapacityListService sessionCapacityListService;

	@Autowired
	private ExcelReadComponent excelReadComponent;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	/**
	 * hcCapacityList  화면 호출
	 * @Author KR-SH
	 * @Date 2019. 11. 18.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initHcCapacityList.do")
	public String initHcCapacityList(@RequestParam Map<String, Object> params, ModelMap model) {
		params.put("groupCode", HomecareConstants.HDC_BRANCH_TYPE);

		List<EgovMap> dscBranchList =   sessionCapacityListService.seleBranchCodeSearch(params);
		model.addAttribute("dscBranchList", dscBranchList);
		model.addAttribute("branchTypeId", HomecareConstants.HDC_BRANCH_TYPE);
		model.addAttribute("memberTypeId", HomecareConstants.MEM_TYPE.DT);

		return "homecare/services/plan/hcCapacityList";
	}

	/**
	 * Homecare Capacity List 저장
	 * @Author KR-SH
	 * @Date 2019. 11. 19.
	 * @param params
	 * @param sessionVO
	 * @return
	 */
	@RequestMapping(value = "/saveHcCapacityList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage>saveHcCapacityList(@RequestBody Map<String, List<Map<String, Object>>> params, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		boolean updateSuccess = hcCapacityListService.saveHcCapacityList(params, sessionVO);

		if(updateSuccess) {
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		} else {
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
		return ResponseEntity.ok(message);
	}


	/**
	 * Homecare Capacity ExcelList 저장
	 * @Author KR-SH
	 * @Date 2019. 11. 20.
	 * @param request
	 * @param sessionVO
	 * @return
	 * @throws IOException
	 * @throws InvalidFormatException
	 */
	@RequestMapping(value = "/saveHcCapacityByExcel.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveHcCapacityByExcel(MultipartHttpServletRequest request, SessionVO sessionVO) throws IOException, InvalidFormatException {
		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("excelFile");

		List<CapacityExcelUploaderDataVO> vos = excelReadComponent.readExcelToList(multipartFile, 2, CapacityExcelUploaderDataVO::create);
		List<Map<String, Object>> updateList = new ArrayList<Map<String, Object>>();

		for (CapacityExcelUploaderDataVO vo : vos) {
			HashMap<String, Object> updateMap = new HashMap<String, Object>();

			updateMap.put("codeId", vo.getBranch1());
			updateMap.put("memId", vo.getCT1());
			updateMap.put("morngSesionAs", vo.getMorngSesionAs());
			updateMap.put("morngSesionIns", vo.getMorngSesionIns());
			updateMap.put("morngSesionRtn", vo.getMorngSesionRtn());
			updateMap.put("aftnonSesionAs", vo.getAftnonSesionAs());
			updateMap.put("aftnonSesionIns", vo.getAftnonSesionIns());
			updateMap.put("aftnonSesionRtn", vo.getAftnonSesionRtn());
			updateMap.put("evngSesionAs", vo.getEvngSesionAs());
			updateMap.put("evngSesionIns", vo.getEvngSesionIns());
			updateMap.put("evngSesionRtn", vo.getEvngSesionRtn());

			// update datas
			updateList.add(updateMap);
		}

		// 파일 유효성 검사
		List<CapacityExcelUploaderDataVO> vosValid = excelReadComponent.readExcelToList(multipartFile, 1, CapacityExcelUploaderDataVO::create);
		String morngSesionAsValid = vosValid.get(0).getMorngSesionAs();
		String morngSesionInsValid = vosValid.get(0).getMorngSesionIns();
		String morngSesionRtnValid = vosValid.get(0).getMorngSesionRtn();

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();

		if (morngSesionAsValid.equals("AS") && morngSesionInsValid.equals("INS") && morngSesionRtnValid.equals("RTN")) {
			boolean updateSuccess = hcCapacityListService.saveHcCapacityByExcel(updateList, sessionVO);

			if(updateSuccess) {
				message.setCode(AppConstants.SUCCESS);
				message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			} else {
				message.setCode(AppConstants.FAIL);
				message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
			}
		} else {
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}

		return ResponseEntity.ok(message);

	}

}
