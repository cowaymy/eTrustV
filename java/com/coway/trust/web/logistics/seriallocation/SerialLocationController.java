/**
 * @author Adrian C.
 **/
package com.coway.trust.web.logistics.seriallocation;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.logistics.seriallocation.SerialLocationService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/SerialLocation")
public class SerialLocationController
{
	private static final Logger logger = LoggerFactory.getLogger(SerialLocationController.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "SerialLocationService")
	private SerialLocationService serialLocationService;

	@RequestMapping(value = "/serialLocation.do")
	public String SerialLocation(@RequestParam Map<String, Object> params)
	{
		return "logistics/SerialLocation/serialLocationList";
	}

	@RequestMapping(value = "/searchSerialLocationList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> searchSerialLocationList(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO)
    throws Exception
	{
		if (!"".equals(params.get("srchcatagorytype")) || null != params.get("srchcatagorytype"))
		{
			List<Object> tmp = (List<Object>) params.get("srchcatagorytype");
			params.put("cateList", tmp);
		}

		if (!"".equals(params.get("materialtype")) || null != params.get("materialtype"))
		{
			List<Object> tmp = (List<Object>) params.get("materialtype");
			params.put("typeList", tmp);
		}

		List<EgovMap> list = serialLocationService.searchSerialLocationList(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/updateItemGrade.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateItemGrade(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO)
    throws Exception
	{

		List<Object> itemGrades = (List<Object>) params.get(AppConstants.AUIGRID_ADD);

		Map<String, Object> paramArray = new HashMap();

		paramArray.put("itemGrades", itemGrades);

		serialLocationService.updateItemGrade(paramArray);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}
}
