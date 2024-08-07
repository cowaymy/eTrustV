package com.coway.trust.biz.sales.order;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
 
public interface OrderReqApplication {
  void insertOrderCancelAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params, List<String> seqs);

  void updateOrderCancelAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params,List<String> seqs);
}
