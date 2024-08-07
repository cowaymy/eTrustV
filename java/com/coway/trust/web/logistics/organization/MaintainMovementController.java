/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.web.logistics.organization;

import java.util.ArrayList;
import java.util.HashMap;
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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.organization.LocationService;
import com.coway.trust.biz.logistics.organization.MaintainMovementService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/organization")
public class MaintainMovementController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "maintainService")
	private MaintainMovementService maintain;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private SessionHandler sessionHandler;
	

	@RequestMapping(value = "/Movement.do")
	public String listdevice(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		return "logistics/Organization/maintain";
	}

	@RequestMapping(value = "/MaintainmovementList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> selectLocationList(@RequestBody Map<String, Object> params, Model model) throws Exception {
		List<EgovMap> list = maintain.selectMaintainMovementList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/MovementIns.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> materialUpdateItemType(@RequestBody Map<String, ArrayList<Object>> params,
			Model model) {

		List<Object> insList = params.get(AppConstants.AUIGRID_ADD); 
		List<Object> updList = params.get(AppConstants.AUIGRID_UPDATE);
		List<Object> remList = params.get(AppConstants.AUIGRID_REMOVE);
		
		Map<String, Object> param = new HashMap();
		param.put("add", insList);
		param.put("upd", updList);
		param.put("rem", remList);
		maintain.insMaintainMovement(param);
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
}
