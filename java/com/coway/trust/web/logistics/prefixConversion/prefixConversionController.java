package com.coway.trust.web.logistics.prefixConversion;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.prefixConversion.prefixConversionService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/prefixConversion")
public class prefixConversionController {
  private static final Logger logger = LoggerFactory.getLogger(prefixConversionController.class);

  @Resource(name = "prefixConversionService")
  private prefixConversionService prefixConversionService;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @RequestMapping(value = "/prefixConversionList.do")
  public String main(@RequestParam Map<String, Object> params, ModelMap model) {
    return "logistics/prefixConversion/prefixConversionList";
  }

  @RequestMapping(value = "/searchPrefixConversionList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> searchPrefixConversionList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
    logger.debug("[START] - searchPrefixConversionList - params : " + params);

    List<EgovMap> prefixConfigList = prefixConversionService.searchPrefixConfigList(params);

    logger.debug("[END] - searchPrefixConversionList");
    return ResponseEntity.ok(prefixConfigList);
  }

  @RequestMapping(value = "/addEditPrefixConversionPop.do")
  public String addEditPrefixConversionPop(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("[START] - addEditPrefixConversionPop - params : " + params);
    model.put("viewType", (String) params.get("viewType"));

    if (params.get("viewType").equals("2")) {
      EgovMap prefixConfigInfo = prefixConversionService.selectPrefixConfigInfo(params);
      model.addAttribute("prefixConfigInfo", prefixConfigInfo);
    }
    logger.debug("[END] - addEditPrefixConversionPop");
    return "logistics/prefixConversion/addEditPrefixConversionPop";
  }

  @RequestMapping(value = "/savePrefixConversion.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> savePrefixConversion(@RequestBody Map<String, Object> params,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("[START] - savePrefixConversion - params : " + params.get("prefixConversion"));

    prefixConversionService.savePrefixConversion(params, sessionVO);

    logger.debug("[END] - savePrefixConversion");
    ReturnMessage result = new ReturnMessage();
    result.setCode(AppConstants.SUCCESS);
    result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(result);
  }

}
