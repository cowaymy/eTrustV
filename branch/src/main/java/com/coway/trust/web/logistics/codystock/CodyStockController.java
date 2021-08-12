package com.coway.trust.web.logistics.codystock;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.logistics.codystock.CodyStockService;
import com.coway.trust.biz.logistics.totalstock.TotalStockService;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/codystock")
public class CodyStockController {
  
  @Value("${app.name}")
  private String appName;
  
  @Resource(name = "CodyStockService")
  private CodyStockService CodyStockService;
  
  private final Logger logger = LoggerFactory.getLogger(this.getClass());
  
  @Autowired
  private MessageSourceAccessor messageAccessor;
  
  @Autowired
  private SessionHandler sessionHandler;
  
  @RequestMapping(value = "/CodyStockReport.do")
  public String stockMovementReport(Model model, HttpServletRequest request, HttpServletResponse response)
      throws Exception {
    
    return "logistics/codystock/CodyStockSummList";
  }
  
  @RequestMapping(value = "/selectTotalBranchList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selecttotalBranchList(@RequestParam Map<String, Object> params) {
    List<EgovMap> codeList = CodyStockService.selectBranchList(params);
    return ResponseEntity.ok(codeList);
  }
  
  @RequestMapping(value = "/getDeptCodeList")
  public ResponseEntity<List<EgovMap>> getDeptCodeList(@RequestParam Map<String, Object> params) throws Exception {
    
    List<EgovMap> deptCodeList = null;
    deptCodeList = CodyStockService.getDeptCodeList(params);
    
    return ResponseEntity.ok(deptCodeList);
  }
  
  @RequestMapping(value = "/getCodyCodeList")
  public ResponseEntity<List<EgovMap>> getCodyCodeList(@RequestParam Map<String, Object> params) throws Exception {
    
    List<EgovMap> codyCodeList = null;
    codyCodeList = CodyStockService.getCodyCodeList(params);
    
    return ResponseEntity.ok(codyCodeList);
  }
  
  @RequestMapping(value = "/selectCMGroupList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> selectCMGroupList(@RequestParam Map<String, Object> params) {
    List<EgovMap> codeList = CodyStockService.selectCMGroupList(params);
    return ResponseEntity.ok(codeList);
  }
  
}
