import 'package:flutter/material.dart';
import 'package:report_flow/core/models/report_flow_types.dart';

class CustomerInfoCard extends StatefulWidget {
  final CustomerInformation info;

  final Function(CustomerInformation) onInfoUpdate;

  const CustomerInfoCard({
    super.key,
    required this.info,
    required this.onInfoUpdate,
  });

  @override
  State<CustomerInfoCard> createState() => _CustomerInfoCardState();
}

class _CustomerInfoCardState extends State<CustomerInfoCard> {
  bool _isEditingOwner = false;
  bool _isEditingRepresentative = false;
  final _ownerFormKey = GlobalKey<FormState>();
  final _representativeFormKey = GlobalKey<FormState>();

  final _ownerNameFocus = FocusNode();
  final _ownerAddressFocus = FocusNode();
  final _ownerEmailFocus = FocusNode();
  final _ownerContactFocus = FocusNode();
  final _ownerPhoneFocus = FocusNode();

  final _representativeNameFocus = FocusNode();
  final _representativeAddressFocus = FocusNode();
  final _representativeContactFocus = FocusNode();
  final _representativePhoneFocus = FocusNode();

  late FacilityOwnerInfo _editedOwnerInfo;
  late RepresentativeInfo _editedRepresentativeInfo;

  @override
  void initState() {
    super.initState();
    _editedOwnerInfo = widget.info.facilityOwnerInfo;
    _editedRepresentativeInfo = widget.info.representativeInfo;
  }

  @override
  void didUpdateWidget(CustomerInfoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.info != widget.info) {
      _editedOwnerInfo = widget.info.facilityOwnerInfo;
      _editedRepresentativeInfo = widget.info.representativeInfo;
    }
  }

  @override
  void dispose() {
    _ownerNameFocus.dispose();
    _ownerAddressFocus.dispose();
    _ownerEmailFocus.dispose();
    _ownerContactFocus.dispose();
    _ownerPhoneFocus.dispose();

    _representativeNameFocus.dispose();
    _representativeAddressFocus.dispose();
    _representativeContactFocus.dispose();
    _representativePhoneFocus.dispose();

    super.dispose();
  }

  void _toggleOwnerEdit() {
    setState(() {
      _isEditingOwner = !_isEditingOwner;
      if (!_isEditingOwner) {
        _editedOwnerInfo = widget.info.facilityOwnerInfo;
      }
    });
  }

  void _toggleRepresentativeEdit() {
    setState(() {
      _isEditingRepresentative = !_isEditingRepresentative;
      if (!_isEditingRepresentative) {
        _editedRepresentativeInfo = widget.info.representativeInfo;
      }
    });
  }

  void _saveOwnerInfo() {
    if (_ownerFormKey.currentState?.validate() ?? false) {
      _ownerFormKey.currentState?.save();
      final updatedInfo = CustomerInformation(
        facilityOwnerInfo: _editedOwnerInfo,
        representativeInfo: widget.info.representativeInfo,
      );
      widget.onInfoUpdate(updatedInfo);
      _toggleOwnerEdit();
    } else {
      final ownerNameField = _ownerNameFocus.context
          ?.findAncestorWidgetOfExactType<TextFormField>();
      if (ownerNameField?.controller?.text.isEmpty ?? true) {
        _ownerNameFocus.requestFocus();
      } else {
        _ownerAddressFocus.requestFocus();
      }
    }
  }

  void _saveRepresentativeInfo() {
    if (_representativeFormKey.currentState?.validate() ?? false) {
      _representativeFormKey.currentState?.save();
      final updatedInfo = CustomerInformation(
        facilityOwnerInfo: widget.info.facilityOwnerInfo,
        representativeInfo: _editedRepresentativeInfo,
      );
      widget.onInfoUpdate(updatedInfo);
      _toggleRepresentativeEdit();
    } else {
      final representativeNameField = _representativeNameFocus.context
          ?.findAncestorWidgetOfExactType<TextFormField>();
      if (representativeNameField?.controller?.text.isEmpty ?? true) {
        _representativeNameFocus.requestFocus();
      } else {
        _representativeAddressFocus.requestFocus();
      }
    }
  }

  Widget _buildOwnerTile(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(
          'Facility Owner',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child:
                _isEditingOwner ? _buildOwnerForm() : _buildOwnerInfo(context),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerForm() {
    return Form(
      key: _ownerFormKey,
      child: Column(
        children: [
          TextFormField(
            focusNode: _ownerNameFocus,
            initialValue: _editedOwnerInfo.owner,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Name is required' : null,
            onSaved: (value) => _editedOwnerInfo =
                _editedOwnerInfo.copyWith(owner: value ?? ''),
            onFieldSubmitted: (value) =>
                FocusScope.of(context).requestFocus(_ownerAddressFocus),
          ),
          TextFormField(
            focusNode: _ownerAddressFocus,
            initialValue: _editedOwnerInfo.address,
            decoration: const InputDecoration(labelText: 'Address'),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Address is required' : null,
            onSaved: (value) => _editedOwnerInfo =
                _editedOwnerInfo.copyWith(address: value ?? ''),
            onFieldSubmitted: (value) =>
                FocusScope.of(context).requestFocus(_ownerEmailFocus),
          ),
          TextFormField(
            focusNode: _ownerEmailFocus,
            initialValue: _editedOwnerInfo.email,
            decoration: const InputDecoration(labelText: 'Email'),
            onSaved: (value) => _editedOwnerInfo = _editedOwnerInfo.copyWith(
                email: value?.isEmpty ?? true ? 'UNKNOWN' : value),
            onFieldSubmitted: (value) =>
                FocusScope.of(context).requestFocus(_ownerContactFocus),
          ),
          TextFormField(
            focusNode: _ownerContactFocus,
            initialValue: _editedOwnerInfo.contact,
            decoration: const InputDecoration(labelText: 'Contact'),
            onSaved: (value) => _editedOwnerInfo = _editedOwnerInfo.copyWith(
                contact: value?.isEmpty ?? true ? 'MANAGER' : value),
            onFieldSubmitted: (value) =>
                FocusScope.of(context).requestFocus(_ownerPhoneFocus),
          ),
          TextFormField(
            focusNode: _ownerPhoneFocus,
            initialValue: _editedOwnerInfo.phone,
            decoration: const InputDecoration(labelText: 'Phone'),
            onSaved: (value) => _editedOwnerInfo = _editedOwnerInfo.copyWith(
                phone: value?.isEmpty ?? true ? 'UNKNOWN' : value),
            onFieldSubmitted: (value) => _saveOwnerInfo(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _toggleOwnerEdit,
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _saveOwnerInfo,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Name: ${widget.info.facilityOwnerInfo.owner.isEmpty ? '...' : widget.info.facilityOwnerInfo.owner}'),
        Text('Address: ${widget.info.facilityOwnerInfo.address}'),
        Text('Email: ${widget.info.facilityOwnerInfo.email}'),
        Text('Contact: ${widget.info.facilityOwnerInfo.contact}'),
        Text('Phone: ${widget.info.facilityOwnerInfo.phone}'),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _toggleOwnerEdit,
          ),
        ),
      ],
    );
  }

  Widget _buildRepresentativeTile(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(
          'Representative',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: _isEditingRepresentative
                ? _buildRepresentativeForm()
                : _buildRepresentativeInfo(context),
          ),
        ],
      ),
    );
  }

  Widget _buildRepresentativeForm() {
    return Form(
      key: _representativeFormKey,
      child: Column(
        children: [
          TextFormField(
            focusNode: _representativeNameFocus,
            initialValue: _editedRepresentativeInfo.owner,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Name is required' : null,
            onSaved: (value) => _editedRepresentativeInfo =
                _editedRepresentativeInfo.copyWith(owner: value ?? ''),
            onFieldSubmitted: (_) => FocusScope.of(context)
                .requestFocus(_representativeAddressFocus),
          ),
          TextFormField(
            focusNode: _representativeAddressFocus,
            initialValue: _editedRepresentativeInfo.address,
            decoration: const InputDecoration(labelText: 'Address'),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Address is required' : null,
            onSaved: (value) => _editedRepresentativeInfo =
                _editedRepresentativeInfo.copyWith(address: value ?? ''),
            onFieldSubmitted: (_) => FocusScope.of(context)
                .requestFocus(_representativeContactFocus),
          ),
          TextFormField(
            focusNode: _representativeContactFocus,
            initialValue: _editedRepresentativeInfo.contact,
            decoration: const InputDecoration(labelText: 'Contact'),
            onSaved: (value) => _editedRepresentativeInfo =
                _editedRepresentativeInfo.copyWith(
                    contact: value?.isEmpty ?? true ? 'MANAGER' : value),
            onFieldSubmitted: (_) =>
                FocusScope.of(context).requestFocus(_representativePhoneFocus),
          ),
          TextFormField(
            focusNode: _representativePhoneFocus,
            initialValue: _editedRepresentativeInfo.phone,
            decoration: const InputDecoration(labelText: 'Phone'),
            onSaved: (value) => _editedRepresentativeInfo =
                _editedRepresentativeInfo.copyWith(
                    phone: value?.isEmpty ?? true ? 'UNKNOWN' : value),
            onFieldSubmitted: (_) => _saveRepresentativeInfo(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _toggleRepresentativeEdit,
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _saveRepresentativeInfo,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRepresentativeInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Name: ${widget.info.representativeInfo.owner.isEmpty ? '...' : widget.info.representativeInfo.owner}'),
        Text('Address: ${widget.info.representativeInfo.address}'),
        Text('Contact: ${widget.info.representativeInfo.contact}'),
        Text('Phone: ${widget.info.representativeInfo.phone}'),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _toggleRepresentativeEdit,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildOwnerTile(context),
        const SizedBox(height: 8),
        _buildRepresentativeTile(context),
      ],
    );
  }
}
