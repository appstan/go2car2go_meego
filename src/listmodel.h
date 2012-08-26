/*
 * Author: Christophe Dumez <dchris@gmail.com>
 * License: Public domain (No attribution required)
 * Website: http://cdumez.blogspot.com/
 * Version: 1.0
 */

#ifndef LISTMODEL_H
#define LISTMODEL_H

#include <QAbstractListModel>
#include <QList>
#include <QVariant>

class ListItem: public QObject
{
 Q_OBJECT
public:
  ListItem(QObject* parent = 0) : QObject(parent) {}
  virtual ~ListItem() {}
  virtual QString id() const = 0;
  virtual qreal distance() const = 0;
  virtual QVariant data(int role) const = 0;
  virtual QHash<int, QByteArray> roleNames() const = 0;
  virtual void calculateDistance(const double, const double , const double ){}

signals:
  void dataChanged();
};

class ListModel : public  QAbstractListModel
{
  Q_OBJECT
  Q_PROPERTY( int count READ getCount() NOTIFY countChanged())

public:
  explicit ListModel(ListItem* prototype, QObject* parent = 0);
  ~ListModel();
  int rowCount(const QModelIndex &parent = QModelIndex()) const;
  QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
  void appendRow(ListItem* item);
  void appendRows(const QList<ListItem*> &items);
  void insertRow(int row, ListItem* item);
  bool removeRow(int row, const QModelIndex &parent = QModelIndex());
  bool removeRows(int row, int count, const QModelIndex &parent = QModelIndex());
  ListItem* takeRow(int row);
  ListItem* find(const QString &id) const;
  QModelIndex indexFromItem( const ListItem* item) const;

  void sort();
  static bool itemLessThan(const QPair<ListItem*,int> &left, const QPair<ListItem*,int> &right);

  void clear();
  void clearAll();
  int getCount() { this->count = this->rowCount(); return count; }
  Q_INVOKABLE QVariant get(int row);

Q_SIGNALS:
    void countChanged();
    void numberPopulated(int number);

public slots:
  void positionChanged(const double latitude, const double longitude, const double horizontalAccuracy);

private slots:
  void handleItemChange();

protected:
//  bool canFetchMore(const QModelIndex &parent) const;
//  void fetchMore(const QModelIndex &parent);

private:
  //Q_DISABLE_COPY(ListModel)
  ListItem* m_prototype;
  int count;
  QList<ListItem*> m_list;
};

#endif // LISTMODEL_H
