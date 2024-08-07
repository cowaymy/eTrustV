package com.coway.trust.web.logistics.useFilterBlock;

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
import com.coway.trust.biz.logistics.useFilterBlock.useFilterBlockService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/useFilterBlock")
public class useFilterBlockController {
  private static final Logger logger = LoggerFactory.getLogger(useFilterBlockController.class);

  @Resource(name = "useFilterBlockService")
  private useFilterBlockService useFilterBlockService;

  @Autowired
  private MessageSourceAccessor messageAccessor;

  @RequestMapping(value = "/useFilterBlockList.do")
  public String main(@RequestParam Map<String, Object> params, ModelMap model) {
    return "logistics/useFilterBlock/useFilterBlockList";
  }

  @RequestMapping(value = "/searchUseFilterBlockList.do", method = RequestMethod.GET)
  public ResponseEntity<List<EgovMap>> searchUseFilterBlockList(@RequestParam Map<String, Object> params,
      HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
    logger.debug("[START] - searchUseFilterBlockList");
    String[] arrProductCtgry   = request.getParameterValues("cmbProductCtgry"); // Stock Category
    String[] arrMatType = request.getParameterValues("cmbMatType"); // Stock Type
    String[] arrStatus = request.getParameterValues("cmbStatus"); // Status

    if(arrProductCtgry != null && !CommonUtils.containsEmpty(arrProductCtgry))
      params.put("arrProductCtgry", arrProductCtgry);
    if(arrMatType != null && !CommonUtils.containsEmpty(arrMatType))
      params.put("arrMatType", arrMatType);
    if(arrStatus != null && !CommonUtils.containsEmpty(arrStatus))
      params.put("arrStatus", arrStatus);

    List<EgovMap> useFilterBlockList = useFilterBlockService.searchUseFilterBlockList(params);

    logger.debug("[END] - searchUseFilterBlockList");
    return ResponseEntity.ok(useFilterBlockList);
  }

  @RequestMapping(value = "/addEditUseFilterBlockPop.do")
  public String addEditUseFilterBlockPop(@RequestParam Map<String, Object> params, ModelMap model) {
    logger.debug("[START] - addEditUseFilterBlockPop - params : " + params);
    model.put("viewType", (String) params.get("viewType"));

    if (params.get("viewType").equals("2")) {
      EgovMap useFilterBlockInfo = useFilterBlockService.selectUseFilterBlockInfo(params);
      model.addAttribute("useFilterBlockInfo", useFilterBlockInfo);
    }
    logger.debug("[END] - addEditUseFilterBlockPop");
    return "logistics/useFilterBlock/addEditUseFilterBlockPop";
  }

  @RequestMapping(value = "/saveUseFilterBlock.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> saveUseFilterBlock(@RequestBody Map<String, Object> params,
      HttpServletRequest request, SessionVO sessionVO) {
    logger.debug("[START] - saveUseFilterBlock - params : " + params.get("useFilterBlock"));

    useFilterBlockService.saveUseFilterBlock(params, sessionVO);

    logger.debug("[END] - saveUseFilterBlock");
    ReturnMessage result = new ReturnMessage();
    result.setCode(AppConstants.SUCCESS);
    result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    return ResponseEntity.ok(result);
  }


}