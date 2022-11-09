package com.coway.trust.biz.attendance.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.attendance.AttendanceService;
import com.coway.trust.biz.payment.payment.service.ClaimResultUploadVO;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;
import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("AttendanceService")
public class AttendanceServiceImpl implements AttendanceService {

	private static final Logger LOGGER = LoggerFactory.getLogger(AttendanceServiceImpl.class);

    @Resource(name = "AttendanceMapper")
    private AttendanceMapper attendanceMapper;

    //@Transactional
	@Override
	public int saveCsvUpload(Map<String, Object> cvsParam) {

		try{

			int batchId =0, result = 0;

			batchId = attendanceMapper.selectCurrentBatchId();

			List<CalendarEventVO> vos = (List<CalendarEventVO>) cvsParam.get("voList");

		    List<Map> list = vos.stream().map(vo -> {Map<String, Object> hm = BeanConverter.toMap(vo);

		        String dateFrom = vo.getDateFrom().trim();
				String dateTo = vo.getDateTo().trim();
				String time = vo.getTime().trim();

				hm.put("atdType", vo.getAttendanceType().trim());
				hm.put("memCode", vo.getMemCode().trim());
				hm.put("managerCode", vo.getManagerCode());
				hm.put("dateFrom",dateFrom);
				hm.put("dateTo", dateTo);
				hm.put("time", time);
				hm.put("crtUserId", cvsParam.get("userId"));

		        return hm;
		      }).collect(Collectors.toList());
		    LOGGER.debug("paramslist  list =====================================>>  " + list);

			int size = 1000;
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

		      bulkMap.put("list", list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));

		      if(cvsParam.get("type")=="ins"){
			      bulkMap.put("batchId", batchId);
		      }else{
			      bulkMap.put("batchId", cvsParam.get("batchId"));
		      }

		      result = attendanceMapper.saveBatchCalDetailList(bulkMap);

		      	if(result<0){
					throw new Error("Unable to upload");
				}
		    }

			return batchId;
		}
		catch(Exception e){
			throw e;
		}
	}

	//@Transactional
	@Override
	public int saveBatchCalMst( Map<String, Object> master) {

		int result = attendanceMapper.saveBatchCalMst(master); // INSERT INTO ATD0001M
		return result;
	}


	@Override
	public int checkDup(Map<String, Object> master) {

		int mResult = attendanceMapper.checkDup(master);

		return mResult;
	}

	//@Transactional
	@Override
	public int disableBatchCalDtl(Map<String, Object> params) {

		int mResult = attendanceMapper.disableBatchCalDtl(params);

		return mResult;
	}

	public int disableBatchAtdRate(Map<String, Object> params) {

		int mResult = attendanceMapper.disableBatchAtdRate(params);

		return mResult;
	}


	 @Override
	  public List<EgovMap> searchAtdUploadList(Map<String, Object> params) {
	    return attendanceMapper.searchAtdUploadList(params);
	  }

	 //@Transactional
	 @Override
	  public void disableBatchCalMst(Map<String, Object> params) {
	      attendanceMapper.disableBatchCalMst(params);
	  }

	 //@Transactional
	 @Override
	  public int deleteUploadBatch(Map<String, Object> params) {

		  int result =	attendanceMapper.deleteUploadBatch(params);

		  return result;

	  }

	 //@Transactional
	 @Override
	 public int approveUploadBatch(Map<String, Object> params) {

    		int result =0,updResult = 0, atdRate = 0;

//    		try{

    			result =	attendanceMapper.approveUploadBatch(params);
    			updResult = attendanceMapper.updateManagerCode(params);
    			attendanceMapper.atdRateCalculation(params);

    			return result;

//    			if(result < 0 || updResult <0){
//    				throw new Error("Unable to approve upload batch");
//    			}
//    			else{
//    				return result;
//    			}
//
//    		}
//    		catch(Throwable ex){
//    			throw ex;
//    		}
	 }


	 @Override
	  public List<EgovMap> selectManagerCode(Map<String, Object> params) {
	    return attendanceMapper.selectManagerCode(params);
	 }

	 @Override
	  public List<EgovMap> searchAtdManagementList(Map<String, Object> params) {
	    return attendanceMapper.searchAtdManagementList(params);
	  }

	 @Override
	  public List<EgovMap> selectYearList(Map<String, Object> params) {
	    return attendanceMapper.selectYearList(params);
	 }




}
