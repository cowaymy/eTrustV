<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

 // AUIGrid 생성 후 반환 ID
    var myGridID;   
    var gridValue;
    var newGridID;
    
    var option = {
        width : "1000px", // 창 가로 크기
        height : "600px" // 창 세로 크기
    };


    //Start AUIGrid
    $(document).ready(function() {
        //createAUIGrid1();
        //fn_confirm();

    });


    function fn_parentReload() {
    	fn_getOrgEventListAjax(); //parent Method (Reload)
    }  
    
    function fn_close(){
        window.close();
    }


    function fn_confirm(){
        //체크로직

        //버튼 활성화
        
       
        
        //그리드 활성화
        //조회결과 리턴
                
        Common.ajax("GET", "/organization/selectPromteDemoteList", $("#myForm").serialize(), function(result) {        
            AUIGrid.setGridData(myGridID, result);
        });               
    }
 



     function fn_confirmMemberEventPromote(val){
        
        var jsonObj = {
          PromoID : $("#promoId").val(),
          memCode : $("#memCode").val()
       
        };
    
        Common.ajax("GET", "/organization/selectMemberPromoEntries" ,  $("#myForm").serialize() , function(result) {
            AUIGrid.setGridData(newGridID, result);
            Common.alert(result.message,fn_parentReload);
        });
    }




/*     function fn_getNewDeptCodeDocNoID() {//
    
    
    } */

    
    function fn_Available_child() {
    	
    	var  isAv=false;
        
    	Common.ajaxSync("GET", "/organization/getAvailableChild.do" , {  REQST_NO: '${promoInfo.reqstNo}'  } , function(result) {
          
    		   if(null != result){
    			    if(  Number(result.asCnt)  <=  Number(result.tobeCnt) )  isAv =true;
        	    }
        });
        
    	//if(isAv ==false)       Common.alert("Need to make a transfer request confirmation for Cody under the CM before promote confirmation");
    	
    	return isAv;
    }

     function fn_saveEventMap(){
        
        //저장
        var vPromoId = ${promoInfo.promoId}; //promoId
        var vStatusId = ${promoInfo.stusId}; //statusId 
        var vPromoTypeId = ${promoInfo.promoTypeId};
         
        if (vStatusId == 10) {
                //Cancel */

                //as-is logic
           /*   if (oo.DoCancelMemberEvent(promoEntry))
                        {
                            MemberEventView view = new MemberEventView();
                            view = ucMemberEventView.LoadMemberEventInfo(promoEntry.PromoID);
                            Panel_Action.Enabled = false;
                            btnSave.Visible = false;
                            RadWindowManager1.RadAlert("<b>This event has been cancelled.</b>", 450, 160, "Event Cancelled", "callBackFn", null);
                        }
                        else
                        {
                            RadWindowManager1.RadAlert("<b>Failed to cancel this event. Please try again later.</b>", 450, 160, "Failed To Cancel", "callBackFn", null);
                        }  */
                        
                         return false;
        
        } else {
             //Complete
             if (vPromoTypeId == 747) {
      
            	 
            	   if(! fn_Available_child()) return ;
            	   
                   if (fn_confirmMemberEventPromote(vPromoId))  {

                   }  else  {


                   }
             }else if (vPromoTypeId == 748){
                    fn_confirmMemberEventPromote(vPromoId);
                    
/*                     if() {
                    
                    }else {
                          alert("Failed to confirm this event. Please try again later.");                    
                    } */
             }else if(vPromoTypeId == 749){
            	 if (fn_confirmMemberEventPromote(vPromoId))  {

                 }  else  {


                 }
             }
        }
    } 
   
   
    
        function fn_tabSize(){
            AUIGrid.resize(myGridID,1000,400); 
        }

    
        function createAUIGrid1(){
        // AUIGrid 칼럼 설정
        var columnLayout = [ {
                    dataField : "memId",
                    headerText : "memId",
                    width : 0
                }, {
                    dataField : "memType",
                    headerText : "memType",
                    width : 0
                }, {
                    dataField : "memberid1",
                    headerText : "memberid1",
                    width : 100
                }, {
                    dataField : "memCode",
                    headerText : "Member Code.",
                    width : 100
                }, {
                    dataField : "name",
                    headerText : "Member Name.",
                    width : 120
                }, {
                    dataField : "code",
                    headerText : "Status",
                    width : 120
                }, {
                    dataField : "",
                    headerText : "Upcode",
                    width : 20,
                    colSpan : 2,
                    renderer : {
                            type : "CheckBoxEditRenderer",
                            editable : true
                      }
                }, {
                    dataField : "",
                    width : 120,
                    colSpan : -1,
                    editRenderer : {// 셀 자체에 드랍다운리스트 출력하고자 할 때
                        type : "DropDownListRenderer",
                        list : ["IPhone 5S", "Galaxy S5", "IPad Air", "Galaxy Note3", "LG G3", "Nexus 10"]
                     }
                }, {
                    dataField : "status",
                    headerText : "",
                    width : 120,
                    renderer : {
                            type : "ButtonRenderer",
                            labelText : "Transfer",
                            onclick : function(rowIndex, columnIndex, value, item) {
                                alert("( " + rowIndex + ", " + columnIndex + " ) " + item.name + " 상세보기 클릭");
                            }
                     }
            
            }];
            
            
            var newColumn=[
                  {dataField:"0", headerText:"OrderNo"},
                  {dataField:"1", headerText:"Month"},
                  {dataField:"2", headerText:"Day"},
                  {dataField:"3", headerText:"Year"},
                  {dataField:"4", headerText:"RejectCode"}
            ];

            // 그리드 속성 설정
            var gridPros = {
                
                // 페이징 사용       
                usePaging : true,
                
                // 한 화면에 출력되는 행 개수 20(기본값:20)
                pageRowCount : 20,
                
                editable : true,
                
                showStateColumn : true, 
                
                displayTreeOpen : true,
                
                selectionMode : "singleRow",
                    
                headerHeight : 30,
                
                // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                skipReadonlyColumns : true,
                
                // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                wrapSelectionMove : true,
                
                // 줄번호 칼럼 렌더러 출력
                showRowNumColumn : true,
        
            };

                myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
/*                 newGridID = AUIGrid.create("#grid_wrap_new", newColumn, gridPros); */
    }
    
    

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Member Promote/Demote Confirmation</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
<!--     <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_confirm()">CONFIRM</a></p></li> -->       
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->

<aside class="title_line"><!-- title_line start -->
<h2>Event Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Request No</th>
    <td>
    <span><c:out value="${promoInfo.reqstNo}"/></span>
    </td>
    <th scope="row">Request Status</th>
    <td>
    <span><c:out value="${promoInfo.name1}"/></span>
    </td>
    <th scope="row">Create At</th>
    <td>
    <span><c:out value="${promoInfo.c1}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Type</th>
    <td colspan="3"><span><c:out value="${promoInfo.codename1}"/></span></td>
    <th scope="row">Create By</th>
    <td><span><c:out value="${promoInfo.c6}"/></span></td>
</tr>
<tr>
    <th scope="row">Level</th>
    <td colspan="3"><span> <c:out value="( ${promoInfo.memLvlFrom}    -  ${promoInfo.memOrgDesc}) To ( ${promoInfo.memLvlTo}    - ${promoInfo.memorgdescription1} )"/> </span></td>
    <th scope="row">Update At</th>
    <td><c:out value="${promoInfo.c5}"/></td>
</tr>
<tr>
    <th scope="row">Superior</th>
    <td colspan="3"><span><c:out value="( ${promoInfo.deptCodeFrom}    - ${promoInfo.c3} ) To ( ${ promoInfo.deptCodeTo}   - ${promoInfo.c4} )"/> </span></td>
    <th scope="row">Update By</th>
    <td><span><c:out value="${promoInfo.c6}"/></span></td>
</tr>
<tr>
    <th scope="row">Member Type</th>
    <td><span><c:out value="${promoInfo.codeName}"/></span></td>
    <th scope="row">Member Code</th>
    <td><span><c:out value="${promoInfo.memCode}"/></span></td>
    <th scope="row">Member NRIC</th>
    <td><span><c:out value="${promoInfo.nric}"/></span></td>
</tr>
<tr>
    <th scope="row">Member Name</th>
    <td colspan="3"><span><c:out value="${promoInfo.name}"/></span></td>
    <th scope="row">Team Code</th>
    <td></td> 
</tr>
<tr>
    <th scope="row">Branch(To)</th>
    <td colspan="5"> <span><c:out value="${promoInfo.brdesc} "/></span> </td>
</tr>
<tr> 
    
    <th scope="row">Remark</th>
    <td colspan="5"><span><c:out value="${promoInfo.rem}"/></span></td>
</tr>
</tbody>
</table><!-- table end -->

</section><!-- search_table end -->

<section class="search_table"><!-- search_table start -->
 <form name="myForm" id="myForm">
     <%-- <td>
    <span><c:out value="${promoInfo.promoId}"/></span>
    </td> --%>
    <input type="hidden" id="promoId" name="promoId" value="${promoInfo.promoId}">
     <input type="hidden" id="memCode" name="memCode" value="${promoInfo.memCode}">
     <input type="hidden" id="memId" name="memId" value="${promoInfo.memId}">
     <input type="hidden" id="branchId" name="branchId" value="${promoInfo.c7} ">
<aside class="title_line"><!-- title_line start -->
<h2>Request Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Confirm Status</th>
    <td>
    <select class="w100p" id="confirmStatus" name="confirmStatus" >
         <option value="" selected></option>
         <option value="04">Complete this event</option>
         <option value="10">Cancel this event</option>
    </select>
    </td>
    
     <th scope="row">Event Apply Date</th>
    <td>
        <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="evtApplyDate"  name="evtApplyDate" value="${promoInfo.evtApplyDt}" /> 
    </td>
    
</tr>
</tbody>
</table><!-- table end -->

<!-- <aside class="title_line"> 
<!-- title_line start 
<h2>Current Downline</h2>
</aside> --> <!-- title_line end --> 

<!-- <article class="grid_wrap">grid_wrap start
<div id="grid_wrap" style="width: 100%; height: 500px; margin: 0 auto;"></div>
<div id="grid_wrap_new"  style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article>grid_wrap end -->
    </form>
</section><!-- search_table end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="javascript:fn_saveEventMap();">SAVE</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
