/**
 *
 */
package com.coway.trust.biz.homecare.po.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.po.HcCreateDeliveryService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Jin
 */

@Service("hcCreateDeliveryService")
public class HcCreateDeliveryServiceImpl extends EgovAbstractServiceImpl implements HcCreateDeliveryService {

	//private static Logger logger = LoggerFactory.getLogger(HcCreateDeliveryServiceImpl.class);

	@Resource(name = "hcCreateDeliveryMapper")
	private HcCreateDeliveryMapper hcCreateDeliveryMapper;

	@Resource(name = "hcDeliveryGrMapper")
	private HcDeliveryGrMapper hcDeliveryGrMapper;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Override
	public int selectPoListCnt(Map<String, Object> params) throws Exception{
		return hcCreateDeliveryMapper.selectPoListCnt(params);
	}

	@Override
	public List<EgovMap> selectPoList(Map<String, Object> params) throws Exception{
		return hcCreateDeliveryMapper.selectPoList(params);
	}

	@Override
	public List<EgovMap> selectPoDetailList(Map<String, Object> params) throws Exception{
		return hcCreateDeliveryMapper.selectPoDetailList(params);
	}

	@Override
	public List<EgovMap> selectDeliveryList(Map<String, Object> params) throws Exception{
		return hcCreateDeliveryMapper.selectDeliveryList(params);
	}

	@Override
	public List<EgovMap> multiHcCreateDelivery(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception{
		List<Object> insertList = (List<Object>)params.get("saveData");
		String poNo = (String)((Map<String, Object>) insertList.get(0)).get("poNo");

		if(StringUtils.isBlank(poNo)){
			throw new ApplicationException(AppConstants.FAIL,
					messageAccessor.getMessage(AppConstants.MSG_NOT_EXIST, new Object[] { "PO NO(String)" }));
		}

		String delvryNo = "";
		synchronized (hcCreateDeliveryMapper) {
			delvryNo =  hcCreateDeliveryMapper.selectHmcDelvryNo();

			Map<String, Object> map = null;

			for(int i=0; i<insertList.size(); i++){
				map = (Map<String, Object>) insertList.get(i);
				map.put("crtUserId", sessionVO.getUserId());
				map.put("updUserId", sessionVO.getUserId());
				map.put("delvryNo", delvryNo);

				if(i == 0){
					// HMC0007M
					hcCreateDeliveryMapper.insertHcCreateDeliveryMain(map);
				}

				// HMC0008D
				hcCreateDeliveryMapper.insertHcCreateDeliveryDetail(map);
			}
		}

		Map<String, Object> sMap = new HashMap<String, Object>();
		sMap.put("sPoNo", poNo);
		return selectDeliveryList(sMap);
	}

	@Override
	public List<EgovMap> deleteHcCreateDelivery(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception{
		List<Object> deleteList = (List<Object>)params.get("deleteData");

		String poNo = (String)((Map<String, Object>) deleteList.get(0)).get("poNo");

		if(StringUtils.isBlank(poNo)){
			throw new ApplicationException(AppConstants.FAIL,
					messageAccessor.getMessage(AppConstants.MSG_NOT_EXIST, new Object[] { "PO NO(String)" }));
		}

		String deliveryNo = "";
		Map<String, Object> detailMap = null;
		for (Object obj : deleteList) {
			detailMap = (Map<String, Object>) obj;
			detailMap.put("crtUserId", sessionVO.getUserId());
			detailMap.put("updUserId", sessionVO.getUserId());

			// Delivery No 단위로 처리.
			if( !deliveryNo.equals((String)detailMap.get("hmcDelvryNo")) ){
				if(  hcCreateDeliveryMapper.selectIsDeleteSearch(detailMap) <= 0 ){
					throw new ApplicationException(AppConstants.FAIL, "This state cannot be deleted.");
				}

				// HMC0008D
				hcCreateDeliveryMapper.deleteHcCreateDeliveryDetail(detailMap);
				// HMC0007M
				hcCreateDeliveryMapper.deleteHcCreateDeliveryMain(detailMap);
			}

			deliveryNo = (String)detailMap.get("hmcDelvryNo");
		}

		Map<String, Object> sMap = new HashMap<String, Object>();
		sMap.put("sPoNo", poNo);
		return selectDeliveryList(sMap);
	}

	@Override
	public List<EgovMap> deliveryHcCreateDelivery(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception{
		List<Object> deliveryList = (List<Object>)params.get("deliveryData");
		String poNo = (String)((Map<String, Object>) deliveryList.get(0)).get("poNo");

		if(StringUtils.isBlank(poNo)){
			throw new ApplicationException(AppConstants.FAIL,
					messageAccessor.getMessage(AppConstants.MSG_NOT_EXIST, new Object[] { "PO NO(String)" }));
		}

		String deliveryNo = "";
		Map<String, Object> detailMap = null;
		for (Object obj : deliveryList) {
			detailMap = (Map<String, Object>) obj;
			detailMap.put("updUserId", sessionVO.getUserId());

			// Delivery No 단위로 처리.
			if( !deliveryNo.equals((String)detailMap.get("hmcDelvryNo")) ){
				if(  hcCreateDeliveryMapper.selectIsDeleteSearch(detailMap) <= 0 ){
					throw new ApplicationException(AppConstants.FAIL, "This state cannot be Delivery.");
				}

				// HMC0007M
				hcCreateDeliveryMapper.updateDeliveryMain(detailMap);
			}

			deliveryNo = (String)detailMap.get("hmcDelvryNo");
		}

		Map<String, Object> sMap = new HashMap<String, Object>();
		sMap.put("sPoNo", poNo);
		return selectDeliveryList(sMap);
	}

	@Override
	public List<EgovMap> selectProductionCompar(Map<String, Object> params) throws Exception{
		return hcCreateDeliveryMapper.selectProductionCompar(params);
	}

	@Override
	public List<EgovMap> cancelDeliveryHc(Map<String, Object> params, SessionVO sessionVO) throws Exception{
		int grCompleteCnt = hcCreateDeliveryMapper.selectGrCompleteCheck(params);
		if(grCompleteCnt > 0){
			throw new ApplicationException(AppConstants.FAIL, "GR completed can not be canceled.");
		}

		List<EgovMap> cdcYnList = hcCreateDeliveryMapper.selectCdcSerialChk(params);
		if( cdcYnList.size() > 0){
			for (EgovMap eMap : cdcYnList) {
				if("Y".equals(eMap.get("serialChk"))){
					String serialChk = hcDeliveryGrMapper.selectLocationSerialChk(eMap);
					if("Y".equals(serialChk)){
						List<EgovMap> grList = hcCreateDeliveryMapper.selectGrNoList(params);
						if(grList.size() > 0){
							for(EgovMap grMap : grList){

								int serialCnt = hcCreateDeliveryMapper.selectSerialCountCheck(grMap);
								if(serialCnt > 0){
									throw new ApplicationException(AppConstants.FAIL, "There is a Serial in progress.[GR NO : " + grMap.get("hmcGrNo") + "]");
								}
							}
						}
					}
				}
			}
		}

		// cancel delivery
		// HMC0010D
		hcCreateDeliveryMapper.deleteDeliveryGrDetail(params);
		// HMC0009M
		hcCreateDeliveryMapper.deleteDeliveryGrMain(params);
		params.put("updUserId", sessionVO.getUserId());
		hcCreateDeliveryMapper.updateInitDelivery(params);

		return selectDeliveryList(params);
	}
}