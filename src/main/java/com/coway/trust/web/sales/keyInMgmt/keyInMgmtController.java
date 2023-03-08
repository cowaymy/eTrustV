package com.coway.trust.web.sales.keyInMgmt;

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
import com.coway.trust.biz.sales.keyInMgmt.keyInMgmtService;
import com.coway.trust.biz.sales.order.vo.KeyInMgmtRawVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/keyInMgmt")
public class keyInMgmtController {

  private static final Logger LOGGER = LoggerFactory.getLogger(keyInMgmtController.class);

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Resource(name = "keyInMgmtService")
  private keyInMgmtService keyInMgmtService;

  @Autowired
	private CsvReadComponent csvReadComponent;


  @RequestMapping(value = "/selectKeyInMgmtList.do")
  public String selectKeyInMgmtList(@RequestParam Map<String, Object> params, ModelMap model) {

    return "sales/order/keyInMgmtList";
  }

  @RequestMapping(value = "/searchKeyinMgmtList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectProgramList(@RequestParam Map<String, Object> params) {
		List<EgovMap> KeyinMgmtList = keyInMgmtService.searchKeyinMgmtList(params);

		return ResponseEntity.ok(KeyinMgmtList);
	}

  @RequestMapping(value = "/saveKeyInId.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveKeyInId(@RequestBody Map<String, ArrayList<Object>> params,
			SessionVO sessionVO) {
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE);

		int totCnt = keyInMgmtService.saveKeyInId(udtList, sessionVO.getUserId());

		LOGGER.info("upd : {}", udtList.toString());
		LOGGER.info("cnt : {}", totCnt);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

  @RequestMapping(value = "/keyInMgmtUploadPop.do")
	public String hcTerritoryNew(@RequestParam Map<String, Object> params, ModelMap model) {
	  	LOGGER.info("===== key in mgmy upload pop =====");
		return "sales/order/keyInMgmtUploadPop";
	}

  @RequestMapping(value = "/excelUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> excelUpload(MultipartHttpServletRequest request, SessionVO sessionVO) throws IOException, InvalidFormatException {
		ReturnMessage message = new ReturnMessage();

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("excelFile");

		// isIncludeHeader - true
		List<KeyInMgmtRawVO> vos = csvReadComponent.readCsvToList(multipartFile, true, KeyInMgmtRawVO::create);
		//step 1 vaild
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("voList", vos);

		EgovMap  vailMap = keyInMgmtService.uploadExcel(param,sessionVO);

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
