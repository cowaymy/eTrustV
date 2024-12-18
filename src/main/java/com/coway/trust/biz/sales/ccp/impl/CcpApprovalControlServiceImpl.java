package com.coway.trust.biz.sales.ccp.impl;

import javax.annotation.Resource;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.ccp.CcpApprovalControlService;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("ccpApprovalControlService")
public class CcpApprovalControlServiceImpl extends EgovAbstractServiceImpl implements CcpApprovalControlService{

  @Resource(name = "ccpApprovalControlMapper")
  private CcpApprovalControlMapper ccpApprovalControlMapper;

  @Override
  public List<EgovMap> selectProductControlList(Map<String, Object> params) throws Exception {
    return ccpApprovalControlMapper.selectProductControlList(params);
  }

  @SuppressWarnings("unchecked")
  @Override
  public void saveProductionControl(Map<String, ArrayList<Object>> params, int userId) {
    List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE);

    updateList.forEach(r -> {
      ((Map<String, Object>) r).put("userId", userId);
      ccpApprovalControlMapper.updateProductControl((Map<String, Object>) r);
    });
  }

  @Override
  public List<EgovMap> selectChsControlList(Map<String, Object> params) throws Exception {
    return ccpApprovalControlMapper.selectChsControlList(params);
  }

  @SuppressWarnings("unchecked")
  @Override
  public void saveChsControl(Map<String, ArrayList<Object>> params, int userId) {
    List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE);

    updateList.forEach(r -> {
      ((Map<String, Object>) r).put("userId", userId);
      ccpApprovalControlMapper.updateChsControl((Map<String, Object>) r);
    });

  }

  @Override
  public List<EgovMap> selectScoreRangeControlList(Map<String, Object> params) throws Exception {
    return ccpApprovalControlMapper.selectScoreRangeControlList(params);
  }

  @SuppressWarnings("unchecked")
  @Override
  public void saveScoreRangeControl(Map<String, ArrayList<Object>> params, int userId) {
    List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE);

    updateList.forEach(r -> {
      ((Map<String, Object>) r).put("userId", userId);
      ccpApprovalControlMapper.updateScoreRangeControl((Map<String, Object>) r);
    });

  }


  @Override
  public EgovMap getScoreRangeControl(Map<String, Object> params){
    return ccpApprovalControlMapper.getScoreRangeControl(params);
  }


  @SuppressWarnings("unchecked")
  @Override
  public void submitScoreRange(Map<String, Object> params) {

	    // TODAY
	    Calendar calendar = Calendar.getInstance();
	    calendar.set(Calendar.HOUR_OF_DAY, 23);
	    calendar.set(Calendar.MINUTE, 59);
	    calendar.set(Calendar.SECOND, 59);
	    calendar.set(Calendar.MILLISECOND, 999);
	    Date today = calendar.getTime();

	    //TOMORROW
	    Calendar calendar1 = Calendar.getInstance();
	    calendar1.add(Calendar.DATE, 1);
	    calendar1.set(Calendar.HOUR_OF_DAY, 0);
	    calendar1.set(Calendar.MINUTE, 0);
	    calendar1.set(Calendar.SECOND, 0);
	    calendar1.set(Calendar.MILLISECOND, 0);
	    Date tomorrow = calendar1.getTime();

	    // FUTURE
	    Calendar calendar2 = Calendar.getInstance();
	    calendar2.set(Calendar.YEAR, 9999);
	    calendar2.set(Calendar.MONTH, 11);
	    calendar2.set(Calendar.DATE, 31);
	    calendar2.set(Calendar.HOUR_OF_DAY, 23);
	    calendar2.set(Calendar.MINUTE, 59);
	    calendar2.set(Calendar.SECOND, 59);
	    calendar2.set(Calendar.MILLISECOND, 999);
	    Date future = calendar2.getTime();

	  //=========================================
	  // EXISTING SCORE RANGE
	  //=========================================
	  params.put("oldEndDate", today);
	  ccpApprovalControlMapper.updateScoreRange(params);

	  //=========================================
	  // NEW SCORE RANGE
	  //=========================================
	  params.put("newStartDate", tomorrow);
	  params.put("newEndDate", future);

	  // INSERT NEW SCORE RANGE
	  ccpApprovalControlMapper.insertScoreRange(params);
  }

  @Override
  public List<EgovMap> selectUnitEntitleControlList(Map<String, Object> params){
    return ccpApprovalControlMapper.selectUnitEntitleControlList(params);
  }

  @SuppressWarnings("unchecked")
  @Override
  public void saveUnitEntitle(Map<String, ArrayList<Object>> params, int userId) {
    List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE);
    List<Object> insertNewList = params.get(AppConstants.AUIGRID_ADD);

    // TODAY
    Calendar calendar = Calendar.getInstance();
    calendar.set(Calendar.HOUR_OF_DAY, 23);
    calendar.set(Calendar.MINUTE, 59);
    calendar.set(Calendar.SECOND, 59);
    calendar.set(Calendar.MILLISECOND, 999);
    Date today = calendar.getTime();

    //TOMORROW
    Calendar calendar1 = Calendar.getInstance();
    calendar1.add(Calendar.DATE, 1);
    calendar1.set(Calendar.HOUR_OF_DAY, 0);
    calendar1.set(Calendar.MINUTE, 0);
    calendar1.set(Calendar.SECOND, 0);
    calendar1.set(Calendar.MILLISECOND, 0);
    Date tomorrow = calendar1.getTime();

    // FUTURE
    Calendar calendar2 = Calendar.getInstance();
    calendar2.set(Calendar.YEAR, 9999);
    calendar2.set(Calendar.MONTH, 11);
    calendar2.set(Calendar.DATE, 31);
    calendar2.set(Calendar.HOUR_OF_DAY, 23);
    calendar2.set(Calendar.MINUTE, 59);
    calendar2.set(Calendar.SECOND, 59);
    calendar2.set(Calendar.MILLISECOND, 999);
    Date future = calendar2.getTime();

    if(updateList != null){
        updateList.forEach(r -> {
          ((Map<String, Object>) r).put("userId", userId);

          //=========================================
    	  // EXISTING UNIT ENTITLEMENT
    	  //=========================================
          ((Map<String, Object>) r).put("oldEndDate", today);
          ccpApprovalControlMapper.updateUnitEntitle((Map<String, Object>) r);

    	  //=========================================
    	  // NEW EDITED UNIT ENTITLEMENT
    	  //=========================================
    	  ((Map<String, Object>) r).put("newStartDate", tomorrow);
          ((Map<String, Object>) r).put("newEndDate", future);

          //INSERT NEW EDITED RECORD
          ccpApprovalControlMapper.insertUnitEntitle((Map<String, Object>) r);
        });
    }


    //=========================================
    // NEW CREATE UNIT ENTITLEMENT
    //=========================================
    if(insertNewList != null){
        insertNewList.forEach(r -> {
          	 ((Map<String, Object>) r).put("newStartDate", tomorrow);

          	 // SET END DATE - NEW UNIT ENTITLEMENT
             ((Map<String, Object>) r).put("newEndDate", future);
        	 ((Map<String, Object>) r).put("userId", userId);

        	 ccpApprovalControlMapper.insertUnitEntitle((Map<String, Object>) r);
        });
     }
  }

  @Override
  public List<EgovMap> selectProdEntitleControlList(Map<String, Object> params){
	  return ccpApprovalControlMapper.selectProdEntitleControlList(params);
  }

  @SuppressWarnings("unchecked")
  @Override
  public void saveProdEntitle(Map<String, ArrayList<Object>> params, int userId) {
	List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE);

    // TODAY
    Calendar calendar = Calendar.getInstance();
    calendar.set(Calendar.HOUR_OF_DAY, 23);
    calendar.set(Calendar.MINUTE, 59);
    calendar.set(Calendar.SECOND, 59);
    calendar.set(Calendar.MILLISECOND, 999);
    Date today = calendar.getTime();

    //TOMORROW
    Calendar calendar1 = Calendar.getInstance();
    calendar1.add(Calendar.DATE, 1);
    calendar1.set(Calendar.HOUR_OF_DAY, 0);
    calendar1.set(Calendar.MINUTE, 0);
    calendar1.set(Calendar.SECOND, 0);
    calendar1.set(Calendar.MILLISECOND, 0);
    Date tomorrow = calendar1.getTime();

    // FUTURE
    Calendar calendar2 = Calendar.getInstance();
    calendar2.set(Calendar.YEAR, 9999);
    calendar2.set(Calendar.MONTH, 11);
    calendar2.set(Calendar.DATE, 31);
    calendar2.set(Calendar.HOUR_OF_DAY, 23);
    calendar2.set(Calendar.MINUTE, 59);
    calendar2.set(Calendar.SECOND, 59);
    calendar2.set(Calendar.MILLISECOND, 999);
    Date future = calendar2.getTime();

    if(updateList != null){
        updateList.forEach(r -> {

        	int count = ccpApprovalControlMapper.getActiveProdEntitle((Map<String, Object>) r);

        	if(count == 0){
        		((Map<String, Object>) r).put("userId", userId);

                //=========================================
          	  	// EXISTING PRODUCT ENTITLEMENT
          	  	//=========================================
                ((Map<String, Object>) r).put("oldEndDate", today);
                ccpApprovalControlMapper.updateProdEntitle((Map<String, Object>) r);

          	  	//=========================================
          	  	// NEW EDITED PRODUCT ENTITLEMENT
          	  	//=========================================
          	  	((Map<String, Object>) r).put("newStartDate", tomorrow);
          	  	((Map<String, Object>) r).put("newEndDate", future);

          	  	//INSERT NEW EDITED RECORD
          	  	ccpApprovalControlMapper.insertProdEntitle((Map<String, Object>) r);
        	}
        });
    }
  }
}
