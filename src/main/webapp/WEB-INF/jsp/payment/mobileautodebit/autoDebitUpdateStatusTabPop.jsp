<article class="tap_area"><!-- tap_area start -->
<aside class="title_line"><!-- title_line start -->
<h3>Update Status</h3>
</aside><!-- title_line end -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:230px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Action<span class="must">*</span></th>
    <td colspan='3'>
         <select class="w100p"  id="action" name="action" placeholder="Active/Approved/Rejected">
            <option value="">Active/Approved/Rejected</option>
            <option value="5">Approved</option>
            <option value="6">Rejected</option>
            <option value="1">Active</option>
        </select>
    </td>
</tr>
<tr id="specInst">
    <th scope="row"><span>Rejected Reason Code</span></th>
	<td colspan='3'>
	 <select class="w100p"  id="rejectReasonCodeList" name="rejectReasonCodeList">
      </select>
	</td>
</tr>
<tr>
    <th scope="row">Remarks</th>
    <td colspan='3'>
    	<textarea cols="40" rows="5"  id="remarks" name="remarks" placeholder="Remarks" maxlength="1000"></textarea>
    </td>
</tr>
</tbody>
</table>
<!-- table end -->
</article>
<!-- tap_area end -->