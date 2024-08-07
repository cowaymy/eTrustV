package com.coway.trust.web.payment.otherpayment.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.otherpayment.service.CustVaExcludeService;
import com.coway.trust.biz.payment.otherpayment.service.CustVaExcludeVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class CustVaExcludeController {

  @Resource(name = "custVaExcludeService")
  private CustVaExcludeService custVaExcludeService;

  @Autowired
  private CsvReadComponent csvReadComponent;

  @RequestMapping(value = "/initCustVaExclude.do")
  public String initUploadBankStatementList(@RequestParam Map<String, Object> params) {
    return "payment/otherpayment/custVaExclude";
  }

  @RequestMapping(value = "/selectCustVaExcludeList.do")
  public ResponseEntity<List<EgovMap>> selectCustVaExcludeList(@RequestParam Map<String, Object> params) {
    List<EgovMap> resultList = custVaExcludeService.selectCustVaExcludeList(params);
    return ResponseEntity.ok(resultList);
  }

  @RequestMapping(value = "/getCustIdByVaNo.do")
  public ResponseEntity<EgovMap> getCustIdByVaNo(@RequestParam Map<String, Object> params) {
    EgovMap result = custVaExcludeService.getCustIdByVaNo(params);
    return ResponseEntity.ok(result);
  }

  @RequestMapping(value = "/saveCustVaExclude.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> saveCustVaExclude(@RequestBody Map<String, Object> params, SessionVO sessionVO) {

    params.put("userId", sessionVO.getUserId());
    System.out.println(params);
    custVaExcludeService.saveCustVaExclude(params);

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage("Saved Successfully");

    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/saveEdit.do", method = RequestMethod.POST)
  public  ResponseEntity<ReturnMessage> saveEdit(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) {

    int userId = sessionVO.getUserId();

    List<Object> updList = params.get(AppConstants.AUIGRID_UPDATE);   // Get gride UpdateList


    if (updList.size() > 0)
      custVaExcludeService.updCustVaExclude(updList, userId);

    // 결과 만들기 예.
    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);
    message.setMessage("Saved Successfully");
    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/custVaExcludeCsvFileUpload.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> custVaExcludeCsvFileUpload(MultipartHttpServletRequest request, SessionVO sessionVO) throws IOException, InvalidFormatException {
    ReturnMessage message = new ReturnMessage();

    String uploadStatus = request.getParameter("uploadStatus");

    Map<String, MultipartFile> fileMap = request.getFileMap();
    MultipartFile multipartFile = fileMap.get("csvFile");
    List<CustVaExcludeVO> vos = csvReadComponent.readCsvToList(multipartFile, true, CustVaExcludeVO::create);

    List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
    for (CustVaExcludeVO vo : vos) {
      HashMap<String, Object> hm = new HashMap<String, Object>();

      hm.put("custVaNo", vo.getCustVaNo());

      list.add(hm);
    }

    Map<String, Object> params = new HashMap<String, Object>();

    params.put("userId", sessionVO.getUserId());
    params.put("uploadStatus", uploadStatus);

    int result = custVaExcludeService.saveCustVaExcludeUpload(params,list);
    if(result > 0){
        message.setMessage("Customer Va Account Number item(s) successfully uploaded.<br />Item(s) uploaded : "+result);
    }else{
      message.setMessage("Failed to upload Customer Va Account Number item(s). Please try again later.");
    }


    return ResponseEntity.ok(message);
  }



}
