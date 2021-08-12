/**
 *
 */
package com.coway.trust.biz.homecare.po.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.homecare.po.HcConfirmPoService;
import com.coway.trust.biz.homecare.po.HcPurchasePriceService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Jin
 *
 */
@Service("hcConfirmPoService")
public class HcConfirmPoServiceImpl extends EgovAbstractServiceImpl implements HcConfirmPoService {

	//private static Logger logger = LoggerFactory.getLogger(HcConfirmPoServiceImpl.class);

	@Resource(name = "hcPurchasePriceService")
	private HcPurchasePriceService hcPurchasePriceService;

	@Resource(name = "hcConfirmPoMapper")
	private HcConfirmPoMapper hcConfirmPoMapper;

	@Override
	public String selectUserSupplierId(Map<String, Integer> params) throws Exception{
		EgovMap info = hcConfirmPoMapper.selectUserSupplierId(params);

		if(info == null || StringUtils.isEmpty((String)info.get("memAccId"))){
			return "";
		}
		return (String)info.get("memAccId");
	}

	@Override
	public int selectHcConfirmPoMainListCnt(Map<String, Object> params) throws Exception{
		return hcConfirmPoMapper.selectHcConfirmPoMainListCnt(params);
	}
	@Override
	public List<EgovMap> selectHcConfirmPoMainList(Map<String, Object> params) throws Exception{
		return hcConfirmPoMapper.selectHcConfirmPoMainList(params);
	}

	@Override
	public List<EgovMap> selectHcConfirmPoSubList(Map<String, Object> params) throws Exception{
		return hcConfirmPoMapper.selectHcConfirmPoSubList(params);
	}

	@Override
	public int multiConfirmPo(Map<String, Object> params, SessionVO sessionVO) throws Exception{
		int saveCnt = 0;
		List<Object> mainList = (List)params.get("mainData");
		String statCd = (String)params.get("statCd");
		String sRm = (String)params.get("rsn");

		if("20".equals(statCd)){
			sRm = StringUtils.isEmpty(sRm)?"":" ∈ Approve Reason:"+sRm;
		}else{
			sRm = StringUtils.isEmpty(sRm)?"":" ∈ Reject Reason:"+sRm;
		}

		List<EgovMap> suppList = hcPurchasePriceService.selectComonCodeList("438");
		HashMap<String, BigDecimal> suppMap = new HashMap<String, BigDecimal>();
		for(EgovMap map : suppList){
			suppMap.put((String)map.get("code"), (BigDecimal) map.get("codeId") );
		}

		Map<String, Object> mainMap = null;
		for (Object obj : mainList) {
			mainMap = (Map<String, Object>) obj;
			mainMap.put("updUserId", sessionVO.getUserId());
			mainMap.put("suppStsCd", suppMap.get(statCd));  // 20:Comfirmed, 30:Reject
			mainMap.put("sRm", sRm);

			hcConfirmPoMapper.updateConfirmPoStat(mainMap);

			if("20".equals(statCd)){
				// CONFIRM QTY 확정.
				hcConfirmPoMapper.updateConfirmPoDetail(mainMap);
			}
		}
		saveCnt++;

		return saveCnt;
	}

}