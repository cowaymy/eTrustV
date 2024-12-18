package com.coway.trust.web.sales.ccp;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.tiles.request.Request;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.payment.refund.service.BatchRefundVO;
import com.coway.trust.biz.sales.ccp.CcpCHSService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.excel.ExcelReadComponent;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.EgovFormBasedFileUtil;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.organization.organization.excel.TerritoryRawDataVO;
import com.coway.trust.web.sales.SalesConstants;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/ccp")
public class CcpCHSController {
  private static final Logger logger = LoggerFactory.getLogger(CcpCHSController.class);

  @Resource(name = "ccpCHSService")
  private CcpCHSService ccpCHSService;

  @Resource(name = "orderDetailService")
  private OrderDetailService orderDetailService;

  // DataBase message accessor....
  @Autowired
  private MessageSourceAccessor messageAccessor;

  @Autowired
  private SessionHandler sessionHandler;

  @Autowired
  private ExcelReadComponent excelReadComponent;

  @Autowired
  private CsvReadComponent csvReadComponent;

  @Value("${web.resource.upload.file}")
  private String uploadDir;

  @Autowired
  private FileService fileService;

  @RequestMapping(value = "/selectCHSList.do")
  public String selectCcpCHSList (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

      return "sales/ccp/ccpCHSList";
  }

  @RequestMapping(value = "/ccpCHSFileUploadPop.do")
  public String ccpCHSFileUploadPop (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

      return "sales/ccp/ccpCHSFileUploadPop";
  }

  @RequestMapping(value = "/csvUpload", method = RequestMethod.POST)
  public ResponseEntity readFile(MultipartHttpServletRequest request,SessionVO sessionVO) throws IOException, InvalidFormatException {
       ReturnMessage message = new ReturnMessage();
      Map<String, MultipartFile> fileMap = request.getFileMap();
      MultipartFile multipartFile = fileMap.get("csvFile");
      List<CHSRawDataVO> vos = csvReadComponent.readCsvToList(multipartFile, true, CHSRawDataVO::create);

      List<Map<String, Object>> detailList = new ArrayList<Map<String, Object>>();
      for (CHSRawDataVO vo : vos) {

          HashMap<String, Object> hm = new HashMap<String, Object>();


          hm.put("custId", vo.getCustId().trim().replace(".0", ""));
          hm.put("month", vo.getMonth().trim().replace(".0", ""));
          hm.put("year", vo.getYear().trim().replace(".0", ""));
          hm.put("chsStatus", vo.getChsStatus().trim());
          hm.put("chsRsn", vo.getChsRsn().trim());
          hm.put("crtUserId", sessionVO.getUserId());
          hm.put("updUserId", sessionVO.getUserId());
          hm.put("custCat", vo.getCustCat().trim());
          hm.put("renCat", vo.getRenCat().trim());
          hm.put("scoreGrp", vo.getScoreGrp().trim());
          hm.put("renUnitEntitle", vo.getRenUnitEntitle().trim());

          detailList.add(hm);
      }

      Map<String, Object> master = new HashMap<String, Object>();

      master.put("crtUserId", sessionVO.getUserId());
      master.put("updUserId", sessionVO.getUserId());
      master.put("chsRem", "CHS File Upload");
      master.put("chsTotItm", vos.size());
      master.put("chsTotSuccess", 0);
      master.put("chsTotFail", 0);

      int result = ccpCHSService.saveCsvUpload(master, detailList);
      if(result > 0){
          //File file = new File("C:\\COWAY_PROJECT\\CommissionDeduction_BatchFiles\\"+multipartFile.getOriginalFilename());
          //multipartFile.transferTo(file);

          message.setMessage("CHS File successfully uploaded.<br />Batch ID : "+result);
          message.setCode(AppConstants.SUCCESS);
      }else{
          message.setMessage("Failed to upload CHS File. Please try again later.");
          message.setCode(AppConstants.FAIL);
      }


      return ResponseEntity.ok(message);
  }

  @RequestMapping(value = "/selectCcpCHSMstList", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCcpCHSMstList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
      logger.debug("params =====================================>>  " + params);

      List<EgovMap> list = ccpCHSService.selectCcpCHSMstList(params);

      logger.debug("list =====================================>>  " + list.toString());
      return ResponseEntity.ok(list);
  }


  @RequestMapping(value = "/ccpCHSDetailViewPop.do")
  public String ccpCHSDetailViewPop(@RequestParam Map<String, Object> params, ModelMap model) {
      logger.debug("params =====================================>>  " + params);

      EgovMap chsBatchInfo = ccpCHSService.selectCHSInfo(params);

      model.addAttribute("chsBatchInfo", chsBatchInfo);
      model.addAttribute("chsBatchItem", new Gson().toJson(chsBatchInfo.get("chsBatchItem")));
      return "sales/ccp/ccpCHSDetailViewPop";
  }


}
