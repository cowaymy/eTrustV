package com.coway.trust.web.logistics.sms;

/**************************************
 * Author	Date				Remark
 * Kit			2018/02/27		Create for SMS Live
 * Kit			2018/03/19		Create for SMS Bulk
 *
 ***************************************/

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.jsoup.helper.StringUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.logistics.sms.SmsService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**************************************
 * Author	Date				Remark
 * Kit			2018/02/27		Create for SMS Live
 *
 ***************************************/
@Controller
@RequestMapping(value = "/logistics/sms")
public class BulkSMSListController {
	private static final Logger logger = LoggerFactory.getLogger(BulkSMSListController.class);

	@Resource(name = "SmsService")
	private SmsService smsService;

	@Autowired
	private AdaptorService adaptorService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/initBulkSMSList.do")
	public String initASManagementList(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "logistics/sms/bulkSMSList";
	}

	@RequestMapping(value = "/selectBulkSmsList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectBulkSmsList(@RequestParam Map<String, Object> params,HttpServletRequest request, Model model) {

		List<EgovMap> list = smsService.selectBulkSmsList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectBulkSmsItem.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectBulkSmsItem(@RequestParam Map<String, Object> params,HttpServletRequest request, Model model) {

		List<EgovMap> mst = smsService.selectBulkSmsList(params);

		params.put("smsPrio", 3);
		List<EgovMap> details = smsService.selectLiveSmsList(params);

		Map<String, Object> map = new HashMap();
		map.put("mst", mst.get(0));
		map.put("details", details);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/uploadSmsBatch.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> uploadSmsBatch(@RequestBody Map<String, ArrayList<Object>> params,
    		Model model, SessionVO sessionVO) throws Exception {

    	List<Object> gridList = params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
    	List<Object> resultItemList = new ArrayList<Object>();
    	Map<String, Object> uploadMap = null;

    	String result = "SUCCESS";
    	int line = 1;
    	boolean validPhNo = true;

    	smsService.deleteSmsTemp();

    	if (gridList.size() > 0) {
    		Map<String, Object> hm = null;
    		for (Object map : gridList) {
    			hm = (HashMap<String, Object>) map;

				// 첫번째 값이 없으면 skip
				if (hm.get("0") == null || String.valueOf(hm.get("0")).equals("")
						|| String.valueOf(hm.get("0")).trim().length() < 1) {
					continue;
				}

    			uploadMap = new HashMap<String, Object>();

    			String msisdn = (String.valueOf(hm.get("0"))).trim();
    			String orderNo = (String.valueOf(hm.get("1"))).trim();
    			String message = (String.valueOf(hm.get("2"))).trim();

				uploadMap.put("msisdn", msisdn);
				uploadMap.put("orderNo", orderNo);
				uploadMap.put("message", message);
				uploadMap.put("totalSms", gridList.size());
				uploadMap.put("line", line);

    			if((msisdn.length() < 10 || msisdn.length() > 11) || (StringUtil.isNumeric(msisdn) == false)){
    				validPhNo = false;
    				//Invalid mobile phone number - msisdn
    				uploadMap.put("validPhNo", validPhNo);
    				result = "FAILED";
    			}

    			smsService.insertSmsView(uploadMap, sessionVO);

				resultItemList.add(uploadMap);
				line++;
    		}

    	}

    	// 결과 만들기.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(result);
    	message.setData(resultItemList);
    	message.setMessage("Uploaded Successfully");

    	return ResponseEntity.ok(message);
    }

	public ResponseEntity<ReturnMessage> insertSmsView(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {

		smsService.insertSmsView(params, sessionVO);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/createBulkSmsBatch.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> createBulkSmsBatch(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {

		smsService.createBulkSmsBatch(params, sessionVO);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

}
