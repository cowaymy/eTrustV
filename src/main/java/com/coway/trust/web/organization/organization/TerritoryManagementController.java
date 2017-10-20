package com.coway.trust.web.organization.organization;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
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
import com.coway.trust.biz.organization.organization.TerritoryManagementService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.config.excel.ExcelReadComponent;
import com.coway.trust.web.organization.organization.excel.TerritoryRawDataVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/organization/territory")

public class TerritoryManagementController {
	private static final Logger logger = LoggerFactory.getLogger(TerritoryManagementController.class);
	
	@Resource(name = "territoryManagementService")
	private TerritoryManagementService territoryManagementService;
	
	@Resource(name = "commonService") 
	private CommonService commonService;
	
	
	@Autowired
	private ExcelReadComponent excelReadComponent;

	
	
	/**
	 * organization territoryList page  
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/territoryList.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		
		// 호출될 화면
		return "organization/organization/territoryList";
	}
	
	
	

	/**
	 * organization territoryList upload page  
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/territoryNew.do")
	public String territoryNew(@RequestParam Map<String, Object> params, ModelMap model) {
		
		// 호출될 화면
		return "organization/organization/territoryNewPop";
	}
	
	 
	
	@RequestMapping(value = "/excelUpload", method = RequestMethod.POST)
	public ResponseEntity readExcel(MultipartHttpServletRequest request) throws IOException, InvalidFormatException {

		
		ReturnMessage message = new ReturnMessage();
		
		logger.debug("comBranchTypep : {}", request.getParameter("comBranchTypep"));
		
		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("excelFile");

		List<TerritoryRawDataVO> vos = excelReadComponent.readExcelToList(multipartFile, TerritoryRawDataVO::create);

		for (TerritoryRawDataVO vo : vos) {
			   logger.debug("vo {}", vo.toString());
		}  
		
		//step 1 vaild 
		Map param = new HashMap();
		param.put("comBranchTypep", request.getParameter("comBranchTypep"));
		param.put("voList", vos);
		
		EgovMap  vailMap = territoryManagementService.uploadVaild(param);
		
		
		logger.debug("vailMap {}", vailMap.toString());
		
		if((boolean)vailMap.get("isErr")){
			message.setCode(AppConstants.FAIL);
			message.setMessage((String)vailMap.get("errMsg"));
		}else{
			
		}
		
		//결과 
		return ResponseEntity.ok(message);
	}
}
