package com.coway.trust.web.sales.ccp;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.ccp.CcpApprovalControlService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/ccp")
public class CcpApprovalControlController {

	@Resource(name = "ccpApprovalControlService")
	private CcpApprovalControlService ccpApprovalControlService;

	@RequestMapping(value = "/ccpApprovalControlList.do")
	public String ccpApprovalControlList(@RequestParam Map<String, Object> params) throws Exception{
	  return "sales/ccp/ccpApprovalControl";
	}

	@RequestMapping(value = "/selectProductControlList.do")
  public ResponseEntity<List<EgovMap>> selectProductControlList(@RequestParam Map<String, Object> params) throws Exception{
	  List<EgovMap> ccpProductControlList = ccpApprovalControlService.selectProductControlList(params);

    return ResponseEntity.ok(ccpProductControlList);
  }

	@RequestMapping(value = "/saveProductControl.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> saveProductControl(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) {

	  int userId = sessionVO.getUserId();

    ccpApprovalControlService.saveProductionControl(params, userId);

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);

    return ResponseEntity.ok(message);
  }

	@RequestMapping(value = "/selectChsControlList.do")
  public ResponseEntity<List<EgovMap>> selectChsControlList(@RequestParam Map<String, Object> params) throws Exception{
    List<EgovMap> selectChsControlList = ccpApprovalControlService.selectChsControlList(params);

    return ResponseEntity.ok(selectChsControlList);
  }

	@RequestMapping(value = "/saveChsControl.do", method = RequestMethod.POST)
  public ResponseEntity<ReturnMessage> saveChsControl(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) {

    int userId = sessionVO.getUserId();

    ccpApprovalControlService.saveChsControl(params, userId);

    ReturnMessage message = new ReturnMessage();
    message.setCode(AppConstants.SUCCESS);

    return ResponseEntity.ok(message);
  }

	 @RequestMapping(value = "/selectScoreRangeControlList.do")
	  public ResponseEntity<List<EgovMap>> selectScoreRangeControlList(@RequestParam Map<String, Object> params) throws Exception{
	    List<EgovMap> selectScoreRangeControlList = ccpApprovalControlService.selectScoreRangeControlList(params);

	    return ResponseEntity.ok(selectScoreRangeControlList);
	  }

	  @RequestMapping(value = "/saveScoreRangeControl.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> saveScoreRangeControl(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) {

	    int userId = sessionVO.getUserId();

	    ccpApprovalControlService.saveScoreRangeControl(params, userId);

	    ReturnMessage message = new ReturnMessage();
	    message.setCode(AppConstants.SUCCESS);

	    return ResponseEntity.ok(message);
	  }

}
