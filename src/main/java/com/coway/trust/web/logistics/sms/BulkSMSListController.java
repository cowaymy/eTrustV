package com.coway.trust.web.logistics.sms;

/**************************************
 * Author	Date				Remark
 * Kit			2018/02/27		Create for SMS Live
 * Kit			2018/03/19		Create for SMS Bulk
 * Kit   		2018/11/22		Create for SMS Bulk Upload
 ***************************************/

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.logistics.sms.SmsService;
import com.coway.trust.biz.logistics.sms.SmsUploadVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.util.BeanConverter;
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

	@Autowired
	private CsvReadComponent csvReadComponent;

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

	@RequestMapping(value = "/selectBulkSmsListException.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectBulkSmsListException(@RequestParam Map<String, Object> params,HttpServletRequest request, Model model) {

		List<EgovMap> list = smsService.selectBulkSmsListException(params);

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

	@RequestMapping(value = "/selectBulkSmsItemException.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectBulkSmsItemException(@RequestParam Map<String, Object> params,HttpServletRequest request, Model model) {

		List<EgovMap> mst = smsService.selectBulkSmsListException(params);

		params.put("smsPrio", 3);
		List<EgovMap> details = smsService.selectLiveSmsList(params);

		Map<String, Object> map = new HashMap();
		map.put("mst", mst.get(0));
		map.put("details", details);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value="/smsRawDataPop.do")
	public String orderSalesYSListingPop(){

		return "logistics/sms/smsRawDataPop";
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

	@RequestMapping(value="/selectEnrolmentFilter.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectEnrolmentFilter(@RequestParam Map<String, Object> params) {

		List<EgovMap> codeList = smsService.selectEnrolmentFilter(params);
		return ResponseEntity.ok(codeList);
	}

    @RequestMapping(value = "/uploadSmsBatchBulk.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> uploadSmsBatchBulk(MultipartHttpServletRequest request, SessionVO sessionVO) throws Exception {

		//CVS 파일 세팅
		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("csvFile");
		List<SmsUploadVO> vos = csvReadComponent.readCsvToList(multipartFile,true ,SmsUploadVO::create);

		//CVS 파일 객체 세팅
		Map<String, Object> cvsParam = new HashMap<String, Object>();
		cvsParam.put("voList", vos);
		cvsParam.put("userId", sessionVO.getUserId());

		// cvs 파일 저장 처리
		List<SmsUploadVO> vos2 = (List<SmsUploadVO>) cvsParam.get("voList");

		List<Map> list = vos2.stream().map(r -> {
			Map<String, Object> map = BeanConverter.toMap(r);
			map.put("msg", r.getMsg());
			map.put("msisdn", r.getMsisdn());
			map.put("smsType", 976);
			map.put("priority", 3);
			map.put("ordNo", r.getOrdNo());
			map.put("remark", "");
			map.put("stusId", 1);
			map.put("retryNo", 0);
			map.put("userId", sessionVO.getUserId());
			map.put("vendorId", 2);
			return map;
		}).collect(Collectors.toList());

		String result = AppConstants.SUCCESS;
    	int line = 1;
    	String invalidMsg = "";
    	String validMsg = "";
    	String msg = "";

		Map<String, Object> hm = null;
		for (Object map : list) {
			hm = (HashMap<String, Object>) map;
			String msisdn = (String.valueOf(hm.get("msisdn"))).trim();
			if((msisdn.length() < 10 || msisdn.length() > 11) || (StringUtil.isNumeric(msisdn) == false)){
				invalidMsg += "Invalid Phone Number : " + msisdn + " at Line: " + line + "<br />";
				result = AppConstants.FAIL;
			}
			line++;
		}

		smsService.deleteSmsTemp();
		if(result != AppConstants.FAIL){
    		int size = 500;
    		int page = list.size() / size;
    		int start;
    		int end;

    		Map<String, Object> bulkMap = new HashMap<>();
    		for (int i = 0; i <= page; i++) {
    			start = i * size;
    			end = size;

    			if (i == page) {
    				end = list.size();
    			}

    			if( ((list.size() - start) != 0)){
    				logger.info( i + " :: " + end + " minus " + start);
        			bulkMap.put("list", list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
        			smsService.insertSmsViewBulk(bulkMap);
    			}
    		}

    		validMsg = "Total SMS : " + list.size() + "<br />"
    					+ "<br />Are you sure want to confirm this result ?<br />";
		}

    	// 결과 만들기.
		msg = result == AppConstants.SUCCESS ? validMsg : invalidMsg ;

    	ReturnMessage message = new ReturnMessage();
    	message.setMessage(msg);
    	message.setCode(result);

    	return ResponseEntity.ok(message);
    }

}

