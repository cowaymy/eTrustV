package com.coway.trust.biz.eAccounting.vendorMgmtEmro;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("vendorMgmtEmroService")
public class VendorMgmtEmroServiceImpl implements VendorMgmtEmroService {

	private static final Logger LOGGER = LoggerFactory.getLogger(SampleServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "vendorMgmtEmroMapper")
	private VendorMgmtEmroMapper vendorMgmtEmroMapper;

	@Override
	public List<EgovMap> selectBank() {
		// TODO Auto-generated method stub
		return vendorMgmtEmroMapper.selectBank();
	}

	@Override
	public List<EgovMap> selectSAPCountry() {
		// TODO Auto-generated method stub
		return vendorMgmtEmroMapper.selectSAPCountry();
	}

	@Override
	public List<EgovMap> selectVendorList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return vendorMgmtEmroMapper.selectVendorList(params);
	}

	@Override
	public EgovMap selectVendorInfo(String reqNo) {
		// TODO Auto-generated method stub
		return vendorMgmtEmroMapper.selectVendorInfo(reqNo);
	}

	@Override
	public EgovMap selectVendorInfoMaster(String vendorAccId) {
		// TODO Auto-generated method stub
		return vendorMgmtEmroMapper.selectVendorInfoMaster(vendorAccId);
	}

	@Override
	public List<EgovMap> selectAttachList(String atchFileGrpId) {
		// TODO Auto-generated method stub
		return vendorMgmtEmroMapper.selectAttachList(atchFileGrpId);
	}

	@Override
	public List<EgovMap> getAppvExcelInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return vendorMgmtEmroMapper.getAppvExcelInfo(params);
	}

	@SuppressWarnings("unchecked")
	  @Override
	  public void saveEmroData(Map<String, ArrayList<Object>> params, int userId) {
	    List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE);

	    LOGGER.debug("updateList ============================>> " + updateList);

	    updateList.forEach(r -> {
	      ((Map<String, Object>) r).put("userId", userId);
	      if(((Map<String, Object>) r).get("flg").equals("R")){
	    	  vendorMgmtEmroMapper.updateSyncEmro29D((Map<String, Object>) r);
	    	  vendorMgmtEmroMapper.updateSyncEmro31D((Map<String, Object>) r);
	      }
	      else if(((Map<String, Object>) r).get("flg").equals("M")){
	    	  vendorMgmtEmroMapper.updateSyncEmro31D((Map<String, Object>) r);
	      }
	      LOGGER.debug("updateList ============================>> " + updateList);
	      LOGGER.debug("r ============================>> " + r);

	    });
	  }

}
