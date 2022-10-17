package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.payment.otherpayment.service.TokenIdMaintainService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("tokenIdMaintainService")
public class TokenIdMaintainServiceImpl extends EgovAbstractServiceImpl implements TokenIdMaintainService {

	@Resource(name = "tokenIdMaintainMapper")
	private TokenIdMaintainMapper tokenIdMaintainMapper;

  @Override
  public List<EgovMap> selectTokenIdMaintain(Map<String, Object> params) {
    return tokenIdMaintainMapper.selectTokenIdMaintain(params);
  }

  @Override
  public List<EgovMap> selectTokenIdMaintainDetailPop(Map<String, Object> params) {
    return tokenIdMaintainMapper.selectTokenIdMaintainDetailPop(params);
  }

  @Override
  public List<EgovMap> selectTokenIdMaintainHistoryUpload(Map<String, Object> params) {
    return tokenIdMaintainMapper.selectTokenIdMaintainHistoryUpload(params);
  }

  @Override
  public int saveTokenIdMaintainUploadHistory(Map<String, Object> params) {
    return tokenIdMaintainMapper.saveTokenIdMaintainUploadHistory(params);
  }

  @SuppressWarnings("unchecked")
  @Override
  public int saveTokenIdMaintainUpload(Map<String, Object> params, List<Map<String, Object>> list) {

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
      bulkMap.put("uploadStatus",params.get("uploadStatus").toString());
      bulkMap.put("userId",params.get("userId").toString());
      tokenIdMaintainMapper.saveTokenIdMaintainBulk(bulkMap);
    }


    /*if(list.size() > 0){
      List  buLit = new ArrayList();
      for(int i=0 ; i < list.size() ; i++){
         buLit.add(list.get(i));
      }

      params.put("list", buLit);
      tokenIdMaintainMapper.saveTokenIdMaintainBulk(params);
    }*/

    return list.size();

  }

}
