package com.coway.trust.web.homecare.services.plan;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.homecare.services.plan.HcTerritoryMgtService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.excel.ExcelReadComponent;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.homecare.HomecareConstants;
import com.coway.trust.web.organization.organization.excel.TerritoryRawDataVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcTerritoryMgtController.java
 * @Description : Homecare Territory Management Controller
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 12.   KR-SH        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/homecare/services/plan")
public class HcTerritoryMgtController {

	@Resource(name = "hcTerritoryMgtService")
	private HcTerritoryMgtService hcTerritoryMgtService;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Autowired
	private ExcelReadComponent excelReadComponent;


	/** organization Homecare territoryList page
	 * TO-DO Description
	 * @Author KR-SH
	 * @Date 2019. 11. 13.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/hcTerritoryList.do")
	public String hcTerritoryList(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("branchTypeId", HomecareConstants.HDC_BRANCH_TYPE);
		// 호출될 화면
		return "homecare/services/plan/hcTerritoryList";
	}

	/**
	 * select Homecare territoryList DetailList
	 * @Author KR-SH
	 * @Date 2019. 11. 13.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectHcTerritoryDetailList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHcTerritoryDetailList( @RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> territoryDtlList = hcTerritoryMgtService.selectHcTerritoryDetailList(params);
		return ResponseEntity.ok(territoryDtlList);
	}

	/**
	 * organization territoryList > Current Territory Search page
	 * @Author KR-SH
	 * @Date 2019. 11. 13.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/hcTerritorySearchPop.do")
	public String territorySearchPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("memType", params.get("memType"));
		model.addAttribute("branchTypeId", HomecareConstants.HDC_BRANCH_TYPE);
		// 호출될 화면
		return "homecare/services/plan/hcTerritorySearchPop";
	}

	/**
	 * Search Current Territory list
	 * @Author KR-SH
	 * @Date 2019. 11. 13.
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/selectCurrentHcTerritory.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCurrentHcTerritory( @RequestParam Map<String, Object> params) {
		List<EgovMap> currentTerritoryList = hcTerritoryMgtService.selectCurrentHcTerritory(params);
		return ResponseEntity.ok(currentTerritoryList);
	}

	/**
	 * update Request page
	 * @Author KR-SH
	 * @Date 2019. 11. 13.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/hcTerritoryNew.do")
	public String hcTerritoryNew(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("memType", params.get("memType"));
		model.addAttribute("branchTypeId", HomecareConstants.HDC_BRANCH_TYPE);
		// 호출될 화면
		return "homecare/services/plan/hcTerritoryNewPop";
	}

	/**
	 * update TerritoryList
	 * @Author KR-SH
	 * @Date 2019. 11. 13.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/updateHcTerritoryList.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage>updateHcTerritoryList(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
		boolean success = hcTerritoryMgtService.updateHcTerritoryList(params);

		if(success) {
			message.setMessage("Confirm Success");
		} else {
			message.setMessage("Confirm Fail");
		}
		return ResponseEntity.ok(message);
	}

	/**
	 * Excel Upload
	 * @Author KR-SH
	 * @Date 2019. 11. 13.
	 * @param request
	 * @param sessionVO
	 * @return
	 * @throws IOException
	 * @throws InvalidFormatException
	 */
	@RequestMapping(value = "/excelUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> excelUpload(MultipartHttpServletRequest request, SessionVO sessionVO) throws IOException, InvalidFormatException {
		ReturnMessage message = new ReturnMessage();

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("excelFile");

		// isIncludeHeader - true
		List<TerritoryRawDataVO> vos = excelReadComponent.readExcelToList(multipartFile, true, TerritoryRawDataVO::create);
		//step 1 vaild
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("comBranchTypep", request.getParameter("comBranchTypep"));
		param.put("comMemType", request.getParameter("comMemType"));
		param.put("voList", vos);

		EgovMap  vailMap = hcTerritoryMgtService.uploadExcel(param,sessionVO);

		if((boolean)vailMap.get("isErr")){
			message.setCode(AppConstants.FAIL);
			message.setMessage(CommonUtils.nvl(vailMap.get("errMsg")));
		}else{
			message.setCode(AppConstants.SUCCESS);
			message.setMessage("Excel Upload Success");
		}

		//결과
		return ResponseEntity.ok(message);
	}

}
