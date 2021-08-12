/**
 *
 */
/**
 * @author methree
 *
 */
package com.coway.trust.web.logistics.masterdata;

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
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.logistics.materialdata.MaterialService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/material")
public class MstDataController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "mstdataservice")
	private MaterialService mst;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/mylog007.do")
	public String listdevice(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "logistics/MaterialData/MY_LOG_E007";
	}

	@RequestMapping(value = "/materialcdsearch.do" , method = RequestMethod.POST)
	public ResponseEntity<Map> selectMaterialCodeList(@RequestBody Map<String, Object> params, Model model) throws Exception {

		if (params.get("cmbCategory") != null ){
    		List<String> list = (List)params.get("cmbCategory");
    		if (!list.isEmpty()){
    			String[] cate = new String[list.size()];
    			for (int i = 0 ; i < list.size(); i++){
        			cate[i] = list.get(i);
        		}
        		params.put("catelist" , cate);
    		}
		}

		if (params.get("cmbType") != null ){
    		List<String> list = (List)params.get("cmbType");
    		if (!list.isEmpty()){
    			String[] type = new String[list.size()];
    			for (int i = 0 ; i < list.size(); i++){
        			type[i] = list.get(i);
        		}
        		params.put("typelist" , type);
    		}
		}

		if (params.get("cmbStatus") != null ){
    		List<String> list = (List)params.get("cmbStatus");
    		if (!list.isEmpty()){
    			String[] stat = new String[list.size()];
    			for (int i = 0 ; i < list.size(); i++){
    				stat[i] = list.get(i);
        		}
        		params.put("statlist" , stat);
    		}
		}

		List<EgovMap> codeList = mst.selectStockMstList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", codeList);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/materialitemList.do" , method = RequestMethod.POST)
	public ResponseEntity<Map> selectMaterialItemList(@RequestBody Map<String, Object> params, Model model) throws Exception {
		List<EgovMap> codeList = mst.selectMaterialMstItemList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", codeList);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/materialitemTypeList.do" , method = RequestMethod.GET)
	public ResponseEntity<Map> selectMaterialItemTypeList(@RequestParam Map<String, Object> params, Model model) throws Exception {

		EgovMap codeList = mst.selectMaterialMstItemTypeList();
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/materialUpdateItemType.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> materialUpdateItemType(@RequestBody Map<String, ArrayList<Object>> params,
			Model model) {

		List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE); // 수정 리스트 얻기

		mst.updateMaterialItemType(updateList);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/materialInsertItemType.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> materialInsertItemType(@RequestBody Map<String, Object> params,
			Model model) {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId = 0;

		if(sessionVO==null){
			loginId=99999999;
		}else{
			loginId=sessionVO.getUserId();
		}


		Map<String, Object> insmaterialmap = new HashMap();

		insmaterialmap.put("insitmname", params.get("insitmname"));
		insmaterialmap.put("insitmdesc", params.get("insitmdesc"));
		insmaterialmap.put("insolditemid", params.get("insolditemid"));
		insmaterialmap.put("insuom", params.get("insuom"));
		insmaterialmap.put("inscurrency", params.get("inscurrency"));
		insmaterialmap.put("inscateid", params.get("inscateid"));
		insmaterialmap.put("insprice", params.get("insprice"));
		insmaterialmap.put("insstuscode", params.get("insstuscode"));
		insmaterialmap.put("insitemtype", params.get("inscateid"));
		insmaterialmap.put("loginId", loginId);

		mst.insertMaterialItemType(insmaterialmap);


		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/materialDeleteItemType.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> materialDeleteItemType(ModelMap model, HttpServletRequest request, HttpServletResponse response)
			throws Exception{

		Map<String, Object> materialDelete = new HashMap();

		String itmId        = request.getParameter("itmId");
		materialDelete.put("itmId", itmId);
		mst.deleteMaterialItemType(materialDelete);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}



}