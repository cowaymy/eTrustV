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
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.biz.payment.otherpayment.service.TokenIdMaintainService;
import com.coway.trust.biz.payment.otherpayment.service.TokenIdMaintainVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class TokenIdMaintainController {

  @Resource(name = "tokenIdMaintainService")
  private TokenIdMaintainService tokenIdMaintainService;

  @Autowired
  private CsvReadComponent csvReadComponent;

  @RequestMapping(value = "/tokenIdMaintain.do")
  public String initUploadBankStatementList(@RequestParam Map<String, Object> params) {
    return "payment/otherpayment/tokenIdMaintain";
  }

  @RequestMapping(value = "/selectTokenIdMaintain.do")
  public ResponseEntity<List<EgovMap>> selectTokenIdMaintain(@RequestParam Map<String, Object> params) {

		if(StringUtils.isEmpty(params.get("updStartDt"))) params.put("updStartDt", "01/01/1900");
    	if(StringUtils.isEmpty(params.get("updEndDt")))   params.put("updEndDt",   "31/12/9999");

    	params.put("updStartDt", CommonUtils.changeFormat(String.valueOf(params.get("updStartDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
    	params.put("updEndDt", CommonUtils.changeFormat(String.valueOf(params.get("updEndDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));

    List<EgovMap> resultList = tokenIdMaintainService.selectTokenIdMaintain(params);
    return ResponseEntity.ok(resultList);
  }

  @RequestMapping(value = "/tokenIdMaintainCsvFileUploads.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> tokenIdMaintainCsvFileUploads(MultipartHttpServletRequest request, SessionVO sessionVO) throws IOException, InvalidFormatException {
    ReturnMessage message = new ReturnMessage();

    String uploadStatus = request.getParameter("uploadStatus");
    boolean blankRemark = false;
    boolean blankResponseCode = false;
    boolean blankResponseDesc = false;

    Map<String, MultipartFile> fileMap = request.getFileMap();
    MultipartFile multipartFile = fileMap.get("csvFile");
    List<TokenIdMaintainVO> vos = csvReadComponent.readCsvToList(multipartFile, true, TokenIdMaintainVO::create);

    List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
    for (TokenIdMaintainVO vo : vos) {
      HashMap<String, Object> hm = new HashMap<String, Object>();

      if(CommonUtils.nvl(vo.getResponseDesc()) == ""){
    	  message.setMessage("Failed to upload Token Id Maintenance item(s) : Response Description not allowed blank ");
    	  blankResponseDesc= true;
      break;
      }

      if(CommonUtils.nvl(vo.getResponseCode()) == ""){
    	  message.setMessage("Failed to upload Token Id Maintenance item(s) : Response Code not allowed blank ");
    	  blankResponseCode= true;
      break;
      }

      if(CommonUtils.nvl(vo.getRemark()) == ""){
    	  message.setMessage("Failed to upload Token Id Maintenance item(s) : Remark not allowed blank ");
    	  blankRemark= true;
      break;
      }

      hm.put("tokenId", vo.getTokenId());
      hm.put("cardType", vo.getCardType());
      hm.put("creditCardType", vo.getCreditCardType());
      hm.put("responseCode", vo.getResponseCode());
      hm.put("responseDesc", vo.getResponseDesc());
      hm.put("remark", vo.getRemark());

      list.add(hm);
    }

    Map<String, Object> params = new HashMap<String, Object>();

    params.put("userId", sessionVO.getUserId());
    params.put("uploadStatus", uploadStatus);

    int result = 0;

    if(blankRemark== false && blankResponseCode== false && blankResponseDesc== false)
    	result = tokenIdMaintainService.saveTokenIdMaintainUpload(params,list);

    if(result > 0){
        message.setMessage("Token Id Maintenance successfully uploaded.<br />Item(s) uploaded : "+result);

        params.put("totalCount", result);

        tokenIdMaintainService.saveTokenIdMaintainUploadHistory(params);

    }else{
    	 if(blankRemark== false && blankResponseCode== false && blankResponseDesc== false)
    		 message.setMessage("Failed to upload Token Id Maintenance item(s). Please try again later.");
    }


    return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/selectTokenIdMaintainDetailPop.do")
  public ResponseEntity<List<EgovMap>> selectTokenIdMaintainDetailPop(@RequestParam Map<String, Object> params) {
    List<EgovMap> resultList = tokenIdMaintainService.selectTokenIdMaintainDetailPop(params);
    return ResponseEntity.ok(resultList);
  }

  @RequestMapping(value = "/selectTokenIdMaintainHistoryUpload.do")
  public ResponseEntity<List<EgovMap>> selectTokenIdMaintainHistoryUpload(@RequestParam Map<String, Object> params) {
    List<EgovMap> resultList = tokenIdMaintainService.selectTokenIdMaintainHistoryUpload(params);
    return ResponseEntity.ok(resultList);
  }


}
