package com.coway.trust.biz.organization.organization.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.organization.LoyaltyHPUploadService;
import com.coway.trust.web.organization.organization.LoyaltyHPUploadDataVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("loyaltyHPUploadService")
public class LoyaltyHPUploadServiceImpl extends EgovAbstractServiceImpl implements LoyaltyHPUploadService {


	@Resource(name = "loyaltyHPUploadMapper")
	private LoyaltyHPUploadMapper loyaltyHPUploadMapper;


	@Override
	public String getLoyltyHpUploadMasterUploadId(Map<String, Object> params) {
		return loyaltyHPUploadMapper.getLoyltyHpUploadMasterUploadId(params);
	}


	@Override
	public List<EgovMap> selectLoyaltyActiveHPList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}



	@Override
	public int insertSAL0300Master(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return 0;
	}



	@Override
	public int insertSAL0301Details(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return 0;
	}




	@Override
	public String insertUploadData(List<LoyaltyHPUploadDataVO> vos , String userId ) {

		//master
		Map<String, Object> mMap = new HashMap<String, Object>();

		mMap.put("lotyUploadStatusCode","1");
		mMap.put("lotyApprovalStatusCode","I");
		mMap.put("userId",userId);

		String  uploadId = loyaltyHPUploadMapper.getLoyltyHpUploadMasterUploadId(mMap);

		mMap.put("lotyUploadId",uploadId);

		loyaltyHPUploadMapper.insertSAL0300Master(mMap);

		for (LoyaltyHPUploadDataVO vo : vos) {

			/*det.Updated = DateTime.Now;*/
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("lotyUploadId",uploadId);
			map.put("lotyYear",vo.getLotyYear());
			map.put("lotyPeriod",vo.getLotyPeriod());
			map.put("lotyMemberCode",vo.getLotyMemberCode());
			map.put("lotyMemberStatusCode",vo.getLotyMemberStatusCode());
			map.put("lotyVaildStatusCode","");
			map.put("lotyStartDate",vo.getLotyStartDate());
			map.put("lotyEndDate",vo.getLotyEndDate());
			map.put("userId", userId);



			loyaltyHPUploadMapper.insertSAL0301Details(map);
		}


		return uploadId;
	}


	@Override
	public List<EgovMap> selectLoyaltyHPUploadList(Map<String, Object> params) {

		return 	loyaltyHPUploadMapper.selectLoyaltyHPUploadList(params);
	}


	@Override
	public Map<String, Object>  selectLoyaltyHPUploadDetailInfo(Map<String, Object> params) {

		return loyaltyHPUploadMapper.selectLoyaltyHPUploadDetailInfo(params);
	}


	@Override
	public List<EgovMap> selectLoyaltyHPUploadDetailList(Map<String, Object> params) {

		return 	loyaltyHPUploadMapper.selectLoyaltyHPUploadDetailList(params);
	}


	@Override
	public int  addLoyaltyHpUpload(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return loyaltyHPUploadMapper.addLoyaltyHpUpload(params) ;
	}



	@Override
	public int  removeItem(Map<String, Object> params) {


		List<Object> remove = (List<Object>) params.get("update");

		int rtn =-1;
		if(remove != null){

			for (int i = 0; i < remove.size(); i++) {
			      Map<String, Object> removeMap = (Map<String, Object>)remove.get(i);

			      removeMap.put("lotyUploadId", removeMap.get("lotyUploadId"));
			      removeMap.put("lotyYear",  removeMap.get("lotyYear"));
			      removeMap.put("lotyPeriod",  removeMap.get("lotyPeriod"));
			      removeMap.put("lotyMemberCode",  removeMap.get("lotyMemberCode"));


			      rtn=  loyaltyHPUploadMapper.removeItem(removeMap);

			 }
		}


		// TODO Auto-generated method stub
		return rtn;
	}


	@Override
	public int confrimItem(Map<String, Object> params) {
		return loyaltyHPUploadMapper.confrimItem(params) ;
	}


	@Override
	public int deActiveteItem(Map<String, Object> params) {
		return loyaltyHPUploadMapper.deActiveteItem(params);
	}



	@Override
	public List<EgovMap> selectLoyaltyHPUploadDetailListForMember(Map<String, Object> params) {

		return 	loyaltyHPUploadMapper.selectLoyaltyHPUploadDetailListForMember(params);
	}




	@Override
	public List<EgovMap> selectLoyaltyHPUploadMemberStatusList(Map<String, Object> params) {

		return 	loyaltyHPUploadMapper.selectLoyaltyHPUploadMemberStatusList(params);
	}


}
