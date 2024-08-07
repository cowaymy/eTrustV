/**
 *
 */
package com.coway.trust.web.homecare.po;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.homecare.po.HcItemSearchPopService;
import com.coway.trust.biz.homecare.po.HcPurchasePriceService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Jin
 *
 */
@Controller
@RequestMapping(value = "/homecare/po")
public class HcItemSearchPopController {

	//private static Logger logger = LoggerFactory.getLogger(HcItemSearchPopController.class);

	@Resource(name = "hcPurchasePriceService")
	private HcPurchasePriceService hcPurchasePriceService;


	@Resource(name = "hcItemSearchPopService")
	private HcItemSearchPopService hcItemSearchPopService;


	@RequestMapping(value = "/HcItemSearchPop.do")
	public String HcItemSearchPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		model.addAttribute("url", params);
		// UOM
		model.addAttribute("uomList", hcPurchasePriceService.selectComonCodeList("42"));
		// cur
		model.addAttribute("curList", hcPurchasePriceService.selectComonCodeList("94"));

		return "homecare/po/hcItemSearchPop";
	}

	// main 조회
	@RequestMapping(value = "/selectHcItemSearch.do" , method = RequestMethod.POST)
	public ResponseEntity<Map> selectHcItemSearch(@RequestBody Map<String, Object> params, Model model) throws Exception {

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

		if (params.get("sCodeList") != null ){
    		List<String> list = (List)params.get("sCodeList");
    		if (!list.isEmpty()){
    			String[] code = new String[list.size()];
    			for (int i = 0 ; i < list.size(); i++){
    				code[i] = list.get(i);
        		}
        		params.put("sCodeList" , code);
    		}
		}

		List<EgovMap> codeList = hcItemSearchPopService.selectHcItemSearch(params);

		Map<String, Object> map = new HashMap();
		map.put("data", codeList);

		return ResponseEntity.ok(map);
	}

}
